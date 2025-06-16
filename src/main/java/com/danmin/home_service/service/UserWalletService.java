package com.danmin.home_service.service;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.PaymentStatus;
import com.danmin.home_service.common.TransactionTypeUser;
import com.danmin.home_service.dto.response.UserTransactionResponse;
import com.danmin.home_service.dto.response.WalletResponse;
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

    User getUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found !"));
    }

    UserWallet getWalletUser(Integer userId) {
        return userWalletRepository.findWalletByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Wallet not found !"));
    }

    @Transactional
    public WalletResponse getUserWallet(Long userId) {
        User user = getUserById(userId);

        UserWallet wallet = getWalletUser(user.getId());

        Set<UserTransactionResponse> transactions = user.getUserTransactions().stream()
                .sorted(Comparator.comparing(UserTransaction::getCreatedAt).reversed())
                .map(transaction -> UserTransactionResponse.builder()
                        .transactionId(transaction.getId())
                        .amount(transaction.getAmount())
                        .description(transaction.getDescription())
                        .type(transaction.getType().name())
                        .createdAt(transaction.getCreatedAt()).build())
                .collect(Collectors.toCollection(LinkedHashSet::new));

        return WalletResponse.builder().walletId(wallet.getId()).userId(wallet.getUser().getId())
                .balance(wallet.getBalance()).transactions(transactions).build();
    }

    /**
     * Add funds to a user's wallet and record the transaction
     * 
     * @param userId the user ID
     * @param amount the amount to add (must be positive)
     * @return success message
     */
    @Transactional
    public String rechargeIntoWallet(Long userId, BigDecimal amount) {
        // Validate amount
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new PaymentException("Amount must be greater than zero");
        }

        User user = getUserById(userId);
        UserWallet wallet = getWalletUser(user.getId());

        // Format amount for better readability in transaction description
        String formattedAmount = formatCurrency(amount);

        // Update wallet balance
        wallet.setBalance(wallet.getBalance().add(amount));
        wallet.setUpdatedAt(LocalDateTime.now());
        userWalletRepository.save(wallet);

        // Create transaction record
        String description = String.format("Deposit: +%s added to wallet", formattedAmount);
        createTransaction(user, amount, description, TransactionTypeUser.deposit);

        return "Recharged successfully!";
    }

    /**
     * Deduct funds from a user's wallet and record the transaction
     * 
     * @param userId the user ID
     * @param amount the amount to deduct (must be positive)
     */
    @Transactional
    public void debitAccount(Long userId, BigDecimal amount) {
        // Validate amount
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new PaymentException("Amount must be greater than zero");
        }

        User user = getUserById(userId);
        UserWallet wallet = getWalletUser(user.getId());

        // Check if user has sufficient balance
        if (wallet.getBalance().compareTo(amount) < 0) {
            throw new PaymentException("Insufficient balance for payment");
        }

        // Format amount for better readability in transaction description
        String formattedAmount = formatCurrency(amount);

        // Update wallet balance
        wallet.setBalance(wallet.getBalance().subtract(amount));
        wallet.setUpdatedAt(LocalDateTime.now());
        userWalletRepository.save(wallet);

        // Create transaction record
        String description = String.format("Payment: -%s deducted from wallet", formattedAmount);
        createTransaction(user, amount.negate(), description, TransactionTypeUser.payment);
    }

    /**
     * Helper method to create a transaction record
     * 
     * @param user        the user
     * @param amount      the transaction amount (positive for credit, negative for
     *                    debit)
     * @param description the transaction description
     * @return the created transaction
     */
    private UserTransaction createTransaction(User user, BigDecimal amount, String description,
            TransactionTypeUser type) {
        UserTransaction transaction = UserTransaction.builder()
                .user(user)
                .amount(amount.abs()) // Store absolute value
                .description(description)
                .type(type)
                .createdAt(LocalDateTime.now()) // Set creation time
                .build();

        return userTransactionRepository.save(transaction);
    }

    /**
     * Format currency amount for display in transaction descriptions
     * 
     * @param amount the amount to format
     * @return formatted currency string
     */
    private String formatCurrency(BigDecimal amount) {
        DecimalFormat format = new DecimalFormat("#,### 'VND'");
        return format.format(amount);
    }

    /**
     * refund: update info in payment, user's wallet, user's transaction
     * 
     */
    public void refund(Long bookingId) {

        Bookings booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        Payments payment = paymentRepository.findPaymentByBookingId(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with bookingId: " + bookingId));

        LocalDateTime createdAt = booking.getCreatedAt();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime scheduleDateTime = booking.getScheduledStart();

        try {
            BigDecimal refundAmount = BigDecimal.ZERO;
            String refundReason = "";

            if (createdAt.plusMinutes(10).isAfter(now)) {
                refundAmount = booking.getTotalPrice();
                refundReason = "Refund 100% - cancelled within 10 minutes of booking";
            } else if (booking.getBookingStatus().equals(BookingStatus.pending)) {
                refundAmount = booking.getTotalPrice();
                refundReason = "Refund 100% - booking not assigned yet";
            } else if (scheduleDateTime != null && now.isBefore(scheduleDateTime.minusHours(6))) {
                refundAmount = booking.getTotalPrice();
                refundReason = "Refund 100% - cancelled at least 6 hours before appointment";
            } else if (scheduleDateTime != null && now.isBefore(scheduleDateTime.minusHours(1))) {
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

                User user = getUserById(booking.getUser().getId().longValue());
                UserWallet wallet = getWalletUser(user.getId());

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

                // Update wallet balance
                wallet.setBalance(wallet.getBalance().add(refundAmount));
                wallet.setUpdatedAt(LocalDateTime.now());
                userWalletRepository.save(wallet);

                createTransaction(user, refundAmount, refundReason, TransactionTypeUser.refund);

            } else {
                log.warn("No refund processed for booking {}", bookingId);
            }
        } catch (Exception e) {
            log.error("Error processing refund for booking {}: {}", bookingId, e.getMessage());
            throw new RuntimeException("Failed to process refund", e);
        }
    }
}
