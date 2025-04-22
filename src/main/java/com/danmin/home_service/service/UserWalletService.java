package com.danmin.home_service.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.Locale;

import org.springframework.stereotype.Service;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.PaymentStatus;
import com.danmin.home_service.exception.PaymentException;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Payments;
import com.danmin.home_service.model.User;
import com.danmin.home_service.model.UserTransaction;
import com.danmin.home_service.model.UserWallet;
import com.danmin.home_service.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "USER-WALLET-SERVICE")
public class UserWalletService {

    private final UserWalletRepository userWalletRepository;
    private final UserRepository userRepository;
    private final UserTransactionRepository userTransactionRepository;
    private final BookingRepository bookingRepository;
    private final PaymentRepository paymentRepository;

    public String rechargeIntoWallet(Long userId, BigDecimal amount) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found !"));

        UserWallet wallet = userWalletRepository.findWalletByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Wallet not found !"));

        BigDecimal balance = wallet.getBalance();

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new PaymentException("Amount must be greater than zero");
        }

        // insert db user_wallet
        balance = balance.add(amount);

        wallet.setBalance(balance);
        wallet.setUpdatedAt(LocalDateTime.now());

        userWalletRepository.save(wallet);

        // insert db user_transaction
        String description = "+ " + amount + " into wallet";

        userTransactionRepository.save(UserTransaction.builder()
                .user(user)
                .amount(amount)
                .description(description)
                .build());

        return "Recharged successfully !";
    }

    public void debitAccount(Long userId, BigDecimal amount) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found !"));

        UserWallet wallet = userWalletRepository.findWalletByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Wallet not found !"));

        BigDecimal balance = wallet.getBalance();

        if (balance.compareTo(amount) <= 0) {
            throw new PaymentException("Balance is not enough to payment");
        }

        balance = balance.subtract(amount);

        wallet.setBalance(balance);
        wallet.setUpdatedAt(LocalDateTime.now());

        userWalletRepository.save(wallet);

        // insert db user_transaction
        String description = "- " + amount + " into wallet";

        userTransactionRepository.save(UserTransaction.builder()
                .user(user)
                .amount(amount)
                .description(description)
                .build());
    }

    public void refund(Long bookingId) {

        Bookings booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        Payments payment = paymentRepository.findPaymentByBookingId(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with bookingId: " + bookingId));

        LocalDateTime createdAt = booking.getCreatedAt();
        LocalDateTime now = LocalDateTime.now();
        String scheduleDate = booking.getScheduledDate();

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, dd/MM/yyyy - hh:mm a", Locale.ENGLISH);
            LocalDateTime scheduleDateTime = LocalDateTime.parse(scheduleDate, formatter);
            BigDecimal refundAmount = BigDecimal.ZERO;
            String refundReason = "";

            if (createdAt.plusMinutes(10).isAfter(now)) {
                refundAmount = booking.getTotalPrice();
                refundReason = "Refund 100% - cancelled within 10 minutes of booking";
            } else if (booking.getBookingStatus().equals(BookingStatus.pending)) {
                refundAmount = booking.getTotalPrice();
                refundReason = "Refund 100% - booking not assigned yet";
            } else if (now.isBefore(scheduleDateTime.minusHours(6))) {
                refundAmount = booking.getTotalPrice();
                refundReason = "Refund 100% - cancelled at least 6 hours before appointment";
            } else if (now.isBefore(scheduleDateTime.minusHours(1))) {
                refundAmount = booking.getTotalPrice().subtract(BigDecimal.valueOf(20.0));
                refundReason = "Partial refund - cancelled between 1-6 hours before appointment";
            } else {
                refundAmount = booking.getTotalPrice().multiply(BigDecimal.valueOf(0.7));
                refundReason = "Refund 70% - cancelled less than 1 hour before appointment";
            }

            // implement refund
            if (refundAmount.compareTo(BigDecimal.ZERO) > 0) {
                String refundResult = rechargeIntoWallet(booking.getUser().getId().longValue(), refundAmount);
                log.info("Refund for booking {}: {} - Amount: {} - Result: {}",
                        bookingId, refundReason, refundAmount, refundResult);

                // update status booking
                booking.setBookingStatus(BookingStatus.cancelled);
                bookingRepository.save(booking);

                PaymentStatus paymentStatus;

                // update payment
                if (refundAmount.compareTo(booking.getTotalPrice()) == 0) {
                    paymentStatus = PaymentStatus.refunded;
                } else {
                    paymentStatus = PaymentStatus.partial_refund;
                }

                payment.setStatus(paymentStatus);
                payment.setRefundAmount(refundAmount);
                payment.setRefundReason(refundReason);
                payment.setRefundDate(new Date());

                paymentRepository.save(payment);

            } else {
                log.warn("No refund processed for booking {}", bookingId);
            }
        } catch (DateTimeParseException e) {
            log.error("Error parsing schedule date for booking {}: {}", bookingId, e.getMessage());
            throw new RuntimeException("Invalid schedule date format: " + scheduleDate, e);
        } catch (Exception e) {
            log.error("Error processing refund for booking {}: {}", bookingId, e.getMessage());
            throw new RuntimeException("Failed to process refund", e);
        }
    }
}
