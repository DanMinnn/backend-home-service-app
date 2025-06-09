package com.danmin.home_service.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.danmin.home_service.common.NotificationType;
import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.dto.notification.FCMNotificationResponse;
import com.danmin.home_service.dto.notification.TaskerNotificationResponse;
import com.danmin.home_service.dto.notification.UserNotificationResponse;
import com.danmin.home_service.dto.request.ChatRoomDTO;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.TaskerNotification;
import com.danmin.home_service.model.User;
import com.danmin.home_service.model.UserNotifications;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.TaskerNotificationRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserNotificationRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {
        private final UserNotificationRepository userNotificationRepository;
        private final TaskerNotificationRepository taskerNotificationRepository;
        private final BookingRepository bookingsRepository;
        private final TaskerRepository taskerRepository;
        private final FirebaseNotificationService firebaseNotificationService;
        private final ChatRoomService chatRoomService;
        private final ChatMessageService chatMessageService;
        private final Random random = new Random();

        // Epsilon value for epsilon-greedy algorithm (probability of exploration)
        private static final double EPSILON = 0.2; // 20% chance of random selection
        private static final int DEFAULT_NOTIFICATION_LIMIT = 10;
        public static double randomVal;

        // =================== USER NOTIFICATION METHODS ===================
        public List<UserNotificationResponse> getUserNotifications(Long userId) {
                List<UserNotifications> notifications = userNotificationRepository
                                .findByUserIdOrderByCreatedAtDesc(userId);

                return notifications.stream().map(
                                notification -> UserNotificationResponse.builder()
                                                .id(notification.getId())
                                                .bookingId(notification.getBooking().getId())
                                                .title(notification.getTitle())
                                                .message(notification.getMessage())
                                                .type(notification.getType())
                                                .isRead(notification.getIsRead())
                                                .createdAt(notification.getCreatedAt())
                                                .build())
                                .collect(Collectors.toList());
        }

        public int getUserUnreadCount(Long userId) {
                return userNotificationRepository.countByUserIdAndIsReadFalse(userId);
        }

        public void markUserNotificationAsRead(Long notificationId) {
                UserNotifications notification = userNotificationRepository.findById(notificationId)
                                .orElseThrow(() -> new EntityNotFoundException("User notification not found"));
                notification.setIsRead(true);
                userNotificationRepository.save(notification);
        }

        public void deletedUserNotifications(Long notificationId) {
                userNotificationRepository.deleteById(notificationId);
        }

        // =================== TASKER NOTIFICATION METHODS ===================
        public List<TaskerNotificationResponse> getTaskerNotifications(Long taskerId) {
                List<TaskerNotification> notifications = taskerNotificationRepository
                                .findByTaskerIdOrderByCreatedAtDesc(taskerId);
                return notifications.stream().map(
                                notification -> TaskerNotificationResponse.builder()
                                                .id(notification.getId())
                                                .bookingId(notification.getBooking().getId())
                                                .title(notification.getTitle())
                                                .message(notification.getMessage())
                                                .type(notification.getType())
                                                .isRead(notification.getIsRead())
                                                .createdAt(notification.getCreatedAt())
                                                .build())
                                .collect(Collectors.toList());
        }

        public int getTaskerUnreadCount(Long taskerId) {
                return taskerNotificationRepository.countByTaskerIdAndIsReadFalse(taskerId);
        }

        public void markTaskerNotificationAsRead(Long notificationId) {
                TaskerNotification notification = taskerNotificationRepository.findById(notificationId)
                                .orElseThrow(() -> new EntityNotFoundException("Tasker notification not found"));
                notification.setIsRead(true);
                taskerNotificationRepository.save(notification);
        }

        public void clearTaskerNotifications(Long notificationId) {
                taskerNotificationRepository.deleteById(notificationId);
        }

        // =================== BUSINESS LOGIC METHODS ===================
        public List<TaskerNotification> notifyAvailableTaskers(Long bookingId) {
                Bookings booking = bookingsRepository.findById(bookingId)
                                .orElseThrow(() -> new EntityNotFoundException("Booking not found"));

                Long bookingServiceId = booking.getService().getId();
                List<Tasker> taskersToNotify = new ArrayList<>();

                randomVal = random.nextDouble();
                if (randomVal < EPSILON) {
                        log.info("Using exploration strategy (random taskers) for booking {}", bookingId);
                        taskersToNotify = taskerRepository.findRandomAvailableTaskers(bookingServiceId,
                                        DEFAULT_NOTIFICATION_LIMIT);
                } else {
                        log.info("Using exploitation strategy (high-reputation taskers) for booking {}", bookingId);
                        taskersToNotify = taskerRepository.findAvailableTaskersByReputationAndService(
                                        bookingServiceId, 5);
                }

                List<TaskerNotification> notifications = new ArrayList<>();

                for (Tasker tasker : taskersToNotify) {

                        // Create notification record
                        TaskerNotification notification = TaskerNotification.builder()
                                        .tasker(tasker)
                                        .booking(booking)
                                        .title("New Job Available")
                                        .message("A new " + booking.getService().getName() + " job is available at "
                                                        + booking.getAddress())
                                        .type(NotificationType.NEW_TASK)
                                        .isRead(false)
                                        .build();

                        notifications.add(taskerNotificationRepository.save(notification));

                        // Send push notification
                        sendPushNotificationToTasker(tasker, booking, null);
                }
                return notifications;
        }

        public void notifyJobAccepted(Long bookingId, Long taskerId) {
                Bookings booking = bookingsRepository.findById(bookingId)
                                .orElseThrow(() -> new EntityNotFoundException("Booking not found"));

                Tasker tasker = taskerRepository.findById(taskerId)
                                .orElseThrow(() -> new EntityNotFoundException("Tasker not found"));

                // Create user notification
                UserNotifications userNotification = UserNotifications.builder()
                                .user(booking.getUser())
                                .booking(booking)
                                .title("Job Accepted")
                                .message("Your job has been accepted by " + tasker.getFirstLastName())
                                .type(NotificationType.JOB_ACCEPTED)
                                .isRead(false)
                                .build();

                userNotificationRepository.save(userNotification);

                // Send push notification to user
                sendPushNotificationToUser(booking.getUser(), booking, "Job Accepted", userNotification.getMessage());
        }

        public void notifyJobCompleted(Long bookingId, Long taskerId) {
                Bookings booking = bookingsRepository.findById(bookingId)
                                .orElseThrow(() -> new EntityNotFoundException("Booking not found"));

                Tasker tasker = taskerRepository.findById(taskerId)
                                .orElseThrow(() -> new EntityNotFoundException("Tasker not found"));

                // Create user notification
                UserNotifications userNotification = UserNotifications.builder()
                                .user(booking.getUser())
                                .booking(booking)
                                .title("Job Completed")
                                .message("Your job has been completed by " + tasker.getFirstLastName()
                                                + ". Please rate your experience.")
                                .type(NotificationType.JOB_COMPLETED)
                                .isRead(false)
                                .build();

                userNotificationRepository.save(userNotification);

                // Send push notification to user
                sendPushNotificationToUser(booking.getUser(), booking, "Job Completed", userNotification.getMessage());
        }

        public void notifyJobCancelled(Long bookingId, String reason, String cancelledBy) {
                Bookings booking = bookingsRepository.findById(bookingId)
                                .orElseThrow(() -> new EntityNotFoundException("Booking not found"));

                String title = "Job Cancelled";

                if ("user".equals(cancelledBy)) {
                        // Notify tasker if user cancelled
                        if (booking.getTasker() != null) {
                                TaskerNotification taskerNotification = TaskerNotification.builder()
                                                .tasker(booking.getTasker())
                                                .booking(booking)
                                                .title(title)
                                                .message("The job has been cancelled by the customer. Reason: "
                                                                + reason)
                                                .type(NotificationType.JOB_CANCELLED)
                                                .isRead(false)
                                                .build();

                                taskerNotificationRepository.save(taskerNotification);
                                sendPushNotificationToTasker(booking.getTasker(), booking, null);
                        }
                } else if ("tasker".equals(cancelledBy)) {
                        // Notify user if tasker cancelled
                        UserNotifications userNotification = UserNotifications.builder()
                                        .user(booking.getUser())
                                        .booking(booking)
                                        .title(title)
                                        .message("Your job has been cancelled by the tasker. Reason: " + reason)
                                        .type(NotificationType.JOB_CANCELLED)
                                        .isRead(false)
                                        .build();

                        userNotificationRepository.save(userNotification);
                        sendPushNotificationToUser(booking.getUser(), booking, title, userNotification.getMessage());
                }
        }

        // =================== CHAT NOTIFICATION METHODS ===================
        public Map<String, Object> getUserChatUnreadCount(Long userId) {
                try {
                        // Get all chat rooms for the user
                        List<ChatRoomDTO> chatRooms = chatRoomService.getChatRoomForUser(userId.intValue());

                        int totalUnreadCount = 0;
                        List<Integer> unreadRooms = new ArrayList<>();

                        for (ChatRoomDTO room : chatRooms) {
                                int unreadCount = chatMessageService.getUnreadMessageCount(
                                                room.getId(), userId.intValue(), SenderType.user);
                                if (unreadCount > 0) {
                                        totalUnreadCount += unreadCount;
                                        unreadRooms.add(room.getId());
                                }
                        }

                        Map<String, Object> result = new HashMap<>();
                        result.put("totalUnreadCount", totalUnreadCount);
                        result.put("unreadRooms", unreadRooms);

                        return result;
                } catch (Exception e) {
                        log.error("Error getting user chat unread count for userId: {}", userId, e);
                        return Map.of("totalUnreadCount", 0, "unreadRooms", List.of());
                }
        }

        public Map<String, Object> getTaskerChatUnreadCount(Long taskerId) {
                try {
                        // Get all chat rooms for the tasker
                        List<ChatRoomDTO> chatRooms = chatRoomService.getChatRoomForTasker(taskerId.intValue());

                        int totalUnreadCount = 0;
                        List<Integer> unreadRooms = new ArrayList<>();

                        for (ChatRoomDTO room : chatRooms) {
                                int unreadCount = chatMessageService.getUnreadMessageCount(
                                                room.getId(), taskerId.intValue(), SenderType.tasker);
                                if (unreadCount > 0) {
                                        totalUnreadCount += unreadCount;
                                        unreadRooms.add(room.getId());
                                }
                        }

                        Map<String, Object> result = new HashMap<>();
                        result.put("totalUnreadCount", totalUnreadCount);
                        result.put("unreadRooms", unreadRooms);

                        return result;
                } catch (Exception e) {
                        log.error("Error getting tasker chat unread count for taskerId: {}",
                                        taskerId, e);
                        return Map.of("totalUnreadCount", 0, "unreadRooms", List.of());
                }
        }

        // =================== HELPER METHODS ===================
        private void sendPushNotificationToTasker(Tasker tasker, Bookings booking, Double distanceKm) {
                try {
                        Map<String, String> data = new HashMap<>();
                        data.put("bookingId", booking.getId().toString());
                        data.put("serviceId", booking.getService().getId().toString());
                        data.put("serviceName", booking.getService().getName());
                        data.put("address", booking.getAddress());
                        data.put("customerName", booking.getUser().getFirstLastName());

                        if (distanceKm != null) {
                                data.put("distanceKm", String.format("%.2f", distanceKm));
                        }

                        String title = "New Job Available";
                        String body = "A new " + booking.getService().getName() + " job is available at "
                                        + booking.getAddress();

                        FCMNotificationResponse fcmNotification = FCMNotificationResponse.builder()
                                        .title(title)
                                        .body(body)
                                        .data(data)
                                        .build();

                        boolean sent = firebaseNotificationService.sendNotificationToTasker(
                                        tasker.getId().intValue(), fcmNotification);
                        if (!sent) {
                                log.warn("Failed to send push notification to tasker: {}", tasker.getId());
                        }
                } catch (Exception e) {
                        log.error("Error sending push notification to tasker: {}", tasker.getId(), e);
                }
        }

        private void sendPushNotificationToUser(User user, Bookings booking, String title, String message) {
                try {
                        Map<String, String> data = new HashMap<>();
                        data.put("bookingId", booking.getId().toString());
                        data.put("serviceId", booking.getService().getId().toString());

                        FCMNotificationResponse fcmNotification = FCMNotificationResponse.builder()
                                        .title(title)
                                        .body(message)
                                        .data(data)
                                        .build();

                        boolean sent = firebaseNotificationService.sendNotificationToUser(user.getId(),
                                        fcmNotification);
                        if (!sent) {
                                log.warn("Failed to send push notification to user: {}", user.getId());
                        }
                } catch (Exception e) {
                        log.error("Error sending push notification to user: {}", user.getId(), e);
                }
        }
}
