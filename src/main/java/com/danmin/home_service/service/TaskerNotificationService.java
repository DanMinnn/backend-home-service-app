package com.danmin.home_service.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.danmin.home_service.common.NotificationStatus;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.TaskerNotification;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.TaskerNotificationRepository;
import com.danmin.home_service.repository.TaskerRepository;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TaskerNotificationService {
    private final TaskerRepository taskerRepository;
    private final TaskerNotificationRepository notificationRepository;
    private final BookingRepository bookingsRepository;

    @Value("${app.notification.search-radius-meters}")
    private double searchRadiusMeters;

    @Value("${app.notification.max-taskers}")
    private int maxTaskers;

    public List<TaskerNotification> notifyNearByAvailableTaskers(Long bookingId) {

        Bookings booking = bookingsRepository.findById(bookingId)
                .orElseThrow(() -> new EntityNotFoundException("Booking not found"));

        Long bookingServiceId = booking.getService().getId();

        List<Object[]> nearbyTaskers = taskerRepository.findAvailableTaskersNearby(booking.getLatitude(),
                booking.getLongitude(), searchRadiusMeters, bookingServiceId, maxTaskers);

        List<TaskerNotification> notifications = new ArrayList<>();

        for (Object[] result : nearbyTaskers) {
            Long taskerId = ((Number) result[0]).longValue();
            Double distanceKm = ((Double) result[1]).doubleValue();

            Tasker tasker = taskerRepository.findById(taskerId)
                    .orElseThrow(() -> new RuntimeException("Tasker not found"));

            TaskerNotification notification = TaskerNotification.builder()
                    .tasker(tasker)
                    .booking(booking)
                    .status(NotificationStatus.sent)
                    .distanceKm(distanceKm).build();

            notifications.add(notificationRepository.save(notification));
        }
        return notifications;
    }

    private void sendPushNotification(Tasker tasker, Bookings booking, Double distanceKm) {
        // Implement logic to send push notification via Firebase, WebSocket, etc.
        // Code gửi thông báo thực tế sẽ được thêm vào đây
    }
}
