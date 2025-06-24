package com.danmin.home_service.service;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.danmin.home_service.common.AvailabilityStatus;
import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.TaskerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "BOOKING-SCHEDULE")
public class BookingSchedulerService {

    private final BookingRepository bookingRepository;
    private final TaskerRepository taskerRepository;

    // @PostConstruct
    @Scheduled(fixedRate = 1000 * 60)
    @Transactional
    public void updateAssignedBookingsAndTaskerStatus() {
        LocalDateTime now = LocalDateTime.now();

        List<Bookings> bookings = bookingRepository.findAssignedBookingsInProgressWindow(now);

        for (Bookings booking : bookings) {

            Tasker tasker = taskerRepository.findTaskerByBookingId(booking.getId());
            if (tasker != null) {
                tasker.setAvailabilityStatus(AvailabilityStatus.busy);
                taskerRepository.save(tasker);
            } else {
                log.warn("Tasker not found for booking ID: {}", booking.getId());
            }
            booking.setBookingStatus(BookingStatus.in_progress);

        }

        bookingRepository.saveAll(bookings);
    }

    @Scheduled(fixedRate = 1000 * 60)
    @Transactional
    public void updateBookingCompleted() {
        LocalDateTime now = LocalDateTime.now();

        List<Bookings> bookings = bookingRepository.findInProgressBookingsCompletedWindow(now);

        for (Bookings booking : bookings) {

            Tasker tasker = taskerRepository.findTaskerBusyByBookingId(booking.getId());
            if (tasker != null) {
                tasker.setAvailabilityStatus(AvailabilityStatus.available);
                taskerRepository.save(tasker);
            } else {
                log.warn("Tasker not found for booking ID: {}", booking.getId());
            }

            booking.setBookingStatus(BookingStatus.completed);
        }

        bookingRepository.saveAll(bookings);
    }
}
