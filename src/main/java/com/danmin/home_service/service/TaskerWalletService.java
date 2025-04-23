package com.danmin.home_service.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Locale;

import org.springframework.stereotype.Service;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.TransactionStatus;
import com.danmin.home_service.common.TransactionType;
import com.danmin.home_service.exception.PaymentException;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.TaskerTransaction;
import com.danmin.home_service.model.TaskerWallet;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.TaskerTransactionRepository;
import com.danmin.home_service.repository.TaskerWalletRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "TASKER-WALLET-SERVICE")
public class TaskerWalletService {

    private final TaskerRepository taskerRepository;
    private final TaskerWalletRepository taskerWalletRepository;
    private final TaskerTransactionRepository taskerTransactionRepository;
    private final BookingRepository bookingRepository;

    private Bookings getBookingById(Long bookingId) {
        return bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));
    }

    private Tasker getTaskerById(Long taskerId) {
        return taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));
    }

    public void incomeCompleteTask(Long bookingId, Long taskerId) {

        Bookings booking = getBookingById(bookingId);

        Tasker tasker = getTaskerById(taskerId);

        TaskerWallet taskerWallet = taskerWalletRepository.findWalletByTaskerId(tasker.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Tasker wallet not found with id: " + taskerId));

        if (booking.getBookingStatus().equals(BookingStatus.completed)) {

            BigDecimal income = booking.getTotalPrice().multiply(BigDecimal.valueOf(0.8));
            taskerWallet.setBalance(income);
            taskerWallet.setTasker(tasker);
            taskerWallet.setUpdatedAt(LocalDateTime.now());

            taskerWalletRepository.save(taskerWallet);

            taskerTransactionRepository
                    .save(TaskerTransaction.builder().amount(income).transactionType(TransactionType.INCOME)
                            .transactionStatus(TransactionStatus.SUCCESS)
                            .description("Income from job").build());
        }
    }

    public boolean checkBalanceAccount(Long taskerId, Long bookingId) {

        Bookings booking = getBookingById(bookingId);

        Tasker tasker = getTaskerById(taskerId);

        TaskerWallet taskerWallet = taskerWalletRepository.findWalletByTaskerId(tasker.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Tasker wallet not found with id: " + taskerId));

        BigDecimal balanceCurrent = taskerWallet.getBalance();

        if (balanceCurrent.compareTo(booking.getTotalPrice()) <= 0) {
            return false;
        }

        return true;
    }

    public String rechargeIntoWallet(Long taskerId, BigDecimal amount) {

        Tasker tasker = getTaskerById(taskerId);

        TaskerWallet wallet = taskerWalletRepository.findWalletByTaskerId(tasker.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Wallet not found !"));

        BigDecimal balance = wallet.getBalance();

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new PaymentException("Amount must be greater than zero");
        }

        // insert db tasker_wallet
        balance = balance.add(amount);

        wallet.setBalance(balance);
        wallet.setUpdatedAt(LocalDateTime.now());

        taskerWalletRepository.save(wallet);

        // insert db tasker_transaction
        String description = "+ " + amount + " into wallet";

        taskerTransactionRepository.save(TaskerTransaction.builder()
                .tasker(tasker)
                .amount(amount)
                .description(description)
                .build());

        return "Recharged successfully !";
    }

    public void fineTaskerCancelJob(Long taskerId, Long bookingId, String cancelReason) {

        Tasker tasker = getTaskerById(taskerId);

        Bookings booking = getBookingById(bookingId);

        TaskerWallet wallet = taskerWalletRepository.findWalletByTaskerId(tasker.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Wallet not found !"));
        LocalDateTime now = LocalDateTime.now();
        String scheduleDate = booking.getScheduledDate();

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, dd/MM/yyyy - hh:mm a", Locale.ENGLISH);
            LocalDateTime scheduleDateTime = LocalDateTime.parse(scheduleDate, formatter);
            BigDecimal fineAmount = BigDecimal.ZERO;
            String reason = "";

            if (now.isBefore(scheduleDateTime.minusHours(8))) {
                fineAmount = booking.getTotalPrice().subtract(BigDecimal.valueOf(200000));
                reason = cancelReason;
            } else if (now.isBefore(scheduleDateTime.minusHours(2))) {
                fineAmount = booking.getTotalPrice().multiply(BigDecimal.valueOf(0.5));
                reason = cancelReason;
            } else {
                fineAmount = booking.getTotalPrice().multiply(BigDecimal.valueOf(1));
                reason = cancelReason;
            }

            // implement fine
            if (fineAmount.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal balance = wallet.getBalance();

                wallet.setBalance(balance.subtract(fineAmount));
                wallet.setTasker(tasker);
                wallet.setUpdatedAt(LocalDateTime.now());
                taskerWalletRepository.save(wallet);

                taskerTransactionRepository.save(TaskerTransaction.builder()
                        .amount(fineAmount)
                        .tasker(tasker)
                        .transactionType(TransactionType.ADJUSTMENT)
                        .transactionStatus(TransactionStatus.SUCCESS)
                        .description(reason)
                        .build());
            } else {
                log.warn("Free cancel job for booking {}", bookingId);
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
