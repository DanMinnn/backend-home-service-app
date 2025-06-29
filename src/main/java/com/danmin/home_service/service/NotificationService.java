package com.danmin.home_service.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.danmin.home_service.common.NotificationType;
import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.dto.notification.FCMNotificationResponse;
import com.danmin.home_service.dto.notification.TaskerNotificationResponse;
import com.danmin.home_service.dto.notification.UserNotificationResponse;
import com.danmin.home_service.dto.request.ChatRoomDTO;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.TaskerExposureStats;
import com.danmin.home_service.model.TaskerNotification;
import com.danmin.home_service.model.User;
import com.danmin.home_service.model.UserNotifications;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.TaskerExposureStatsRepository;
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
        private final TaskerExposureStatsRepository taskerExposureStatsRepository;
        private final Random random = new Random();

        private static final double BASE_EPSILON = 0.2; // 20% chance
        private static final int DEFAULT_NOTIFICATION_LIMIT = 10;
        public static double randomVal;

        // The number of bookings used to calculate epsilon
        private static final int EPSILON_RECALCULATION_THRESHOLD = 100;
        // used to adjust epsilon dynamically
        private static int systemBookingCount = 0;

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
        @Async
        public CompletableFuture<List<TaskerNotification>> notifyAvailableTaskers(Long bookingId) {
                Bookings booking = bookingsRepository.findById(bookingId)
                                .orElseThrow(() -> new EntityNotFoundException("Booking not found"));

                List<TaskerNotification> notifications = new ArrayList<>();

                if (booking.getTasker() != null) {
                        TaskerNotification notification = TaskerNotification.builder()
                                        .tasker(booking.getTasker())
                                        .booking(booking)
                                        .title("New Job Available")
                                        .message("A new " + booking.getService().getName() + " job is available at "
                                                        + booking.getAddress())
                                        .type(NotificationType.NEW_TASK)
                                        .isRead(false)
                                        .build();

                        notifications.add(taskerNotificationRepository.save(notification));

                        // Send push notification
                        sendPushNotificationToTasker(booking.getTasker(), booking, null);

                        return CompletableFuture.completedFuture(notifications);
                }

                Long bookingServiceId = booking.getService().getId();
                List<Tasker> taskersToNotify = new ArrayList<>();

                // Increment booking count and potentially adjust epsilon
                systemBookingCount++;
                double currentEpsilon = calculateAdaptiveEpsilon();

                randomVal = random.nextDouble();
                if (randomVal < currentEpsilon) {
                        log.info("Using exploration strategy (weighted selection of underexposed taskers) for booking {}",
                                        bookingId);
                        taskersToNotify = selectTaskersByWeightedExploration(bookingServiceId);
                } else {
                        log.info("Using exploitation strategy (high-reputation taskers) for booking {}", bookingId);
                        taskersToNotify = taskerRepository.findAvailableTaskersByReputationAndService(
                                        bookingServiceId, 5);
                }

                for (Tasker tasker : taskersToNotify) {
                        // Update exposure statistics
                        updateTaskerExposureStats(tasker.getId());

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
                return CompletableFuture.completedFuture(notifications);
        }

        /**
         * Calculates adaptive epsilon value based on system maturity
         * As the system processes more bookings, epsilon gradually decreases
         * to prefer exploitation over exploration
         */
        private double calculateAdaptiveEpsilon() {
                // Start with high exploration, gradually decrease to base value
                if (systemBookingCount < EPSILON_RECALCULATION_THRESHOLD) {
                        return BASE_EPSILON
                                        + (0.3 * (1 - ((double) systemBookingCount / EPSILON_RECALCULATION_THRESHOLD)));
                }
                return BASE_EPSILON;
        }

        /**
         * Updates exposure statistics for a tasker
         * 
         * @param taskerId The tasker's ID
         */
        private void updateTaskerExposureStats(Integer taskerId) {
                TaskerExposureStats stats = taskerExposureStatsRepository
                                .findByTaskerId(taskerId.longValue())
                                .orElseGet(() -> TaskerExposureStats.builder()
                                                .taskerId(taskerId.longValue())
                                                .notificationCount(0L)
                                                .assignedJobCount(0L)
                                                .build());

                stats.setNotificationCount(stats.getNotificationCount() + 1);
                taskerExposureStatsRepository.save(stats);
        }

        /**
         * Selects taskers using weighted exploration based on exposure metrics
         * 
         * @param serviceId The service ID for which taskers are needed
         * @return List of selected taskers
         */
        private List<Tasker> selectTaskersByWeightedExploration(Long serviceId) {
                // Get all available taskers for the service
                List<Tasker> availableTaskers = taskerRepository.findAvailableTaskersByService(serviceId);

                if (availableTaskers.isEmpty()) {
                        log.warn("No available taskers found for service: {}", serviceId);
                        return new ArrayList<>();
                }

                // Calculate weights based on inverse of notification count and recency
                Map<Tasker, Double> taskerWeights = new HashMap<>();

                for (Tasker tasker : availableTaskers) {
                        TaskerExposureStats stats = taskerExposureStatsRepository
                                        .findByTaskerId(tasker.getId().longValue())
                                        .orElseGet(() -> TaskerExposureStats.builder()
                                                        .taskerId(tasker.getId().longValue())
                                                        .notificationCount(0L)
                                                        .assignedJobCount(0L)
                                                        .registrationDate(tasker.getCreatedAt())
                                                        .build());

                        // Calculate base weight (higher for taskers with fewer notifications)
                        double exposureWeight = calculateExposureWeight(stats.getNotificationCount());

                        // New tasker bonus (higher weight for newer taskers)
                        double newTaskerBonus = calculateNewTaskerBonus(stats);

                        // Calculate opportunity ratio (assigned jobs / notifications)
                        double opportunityRatio = calculateOpportunityRatio(stats);

                        // Combine factors
                        double totalWeight = exposureWeight * (1 + newTaskerBonus) * opportunityRatio;

                        taskerWeights.put(tasker, totalWeight);

                        log.debug("Tasker {} weight: {} (exposure: {}, newness: {}, opportunity: {})",
                                        tasker.getId(), totalWeight, exposureWeight, newTaskerBonus, opportunityRatio);
                }

                // Select taskers based on weights
                return weightedRandomSelection(taskerWeights,
                                Math.min(DEFAULT_NOTIFICATION_LIMIT, availableTaskers.size()));
        }

        /**
         * Calculate weight based on exposure (inverse of notification count)
         */
        private double calculateExposureWeight(Long notificationCount) {
                // Higher weight for taskers with fewer notifications
                return 1.0 / (notificationCount + 1.0);
        }

        /**
         * Calculate new tasker bonus (higher for newer taskers)
         */
        private double calculateNewTaskerBonus(TaskerExposureStats stats) {
                // If the tasker has never been assigned a job, give them a significant bonus
                if (stats.getAssignedJobCount() == 0) {
                        return 1.0; // 100% boost
                }
                return 0;
        }

        /**
         * Calculate opportunity ratio (success rate at getting jobs from notifications)
         */
        private double calculateOpportunityRatio(TaskerExposureStats stats) {
                if (stats.getNotificationCount() == 0) {
                        return 2.0; // Highest bonus for never-notified taskers
                }

                // Calculate assigned jobs / notifications ratio
                double ratio = (double) stats.getAssignedJobCount() / stats.getNotificationCount();

                // Invert: we want to give more opportunities to taskers who get fewer jobs
                return 1.0 / (ratio + 0.5);
        }

        /**
         * Performs weighted random selection of taskers
         * 
         * @param weights Map of taskers to their weights
         * @param count   Number of taskers to select
         * @return List of selected taskers
         */
        private List<Tasker> weightedRandomSelection(Map<Tasker, Double> weights, int count) {
                List<Tasker> selectedTaskers = new ArrayList<>();

                // Continue selection until we have enough taskers or run out of candidates
                while (selectedTaskers.size() < count && !weights.isEmpty()) {
                        // Calculate total weight
                        double totalWeight = weights.values().stream().mapToDouble(Double::doubleValue).sum();

                        if (totalWeight <= 0) {
                                // If no weights remain, break
                                break;
                        }

                        // Select a random value between 0 and total weight
                        double randomValue = random.nextDouble() * totalWeight;

                        // Find the tasker corresponding to this value
                        double cumulativeWeight = 0;
                        Tasker selectedTasker = null;

                        for (Map.Entry<Tasker, Double> entry : weights.entrySet()) {
                                cumulativeWeight += entry.getValue();
                                if (cumulativeWeight >= randomValue) {
                                        selectedTasker = entry.getKey();
                                        break;
                                }
                        }

                        // If we found a tasker, add to selected list and remove from candidates
                        if (selectedTasker != null) {
                                selectedTaskers.add(selectedTasker);
                                weights.remove(selectedTasker);
                        } else {
                                // Shouldn't happen, but just in case
                                break;
                        }
                }

                return selectedTaskers;
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
