package com.danmin.home_service.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.model.TaskerNotification;
import com.danmin.home_service.service.TaskerNotificationService;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j(topic = "NOTIFICATION-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Notification Controller")
@RequestMapping("/notifications")
public class NotificationController {
    private final TaskerNotificationService notificationService;

    @PostMapping("/bookings/{bookingId}/notify-taskers")
    public ResponseEntity<?> notifyNearbyTaskers(@PathVariable Long bookingId) {
        List<TaskerNotification> notifications = notificationService.notifyNearByAvailableTaskers(bookingId);
        return ResponseEntity.ok(Map.of(
                "message", "Đã gửi thông báo đến " + notifications.size() + " tasker gần nhất",
                "notificationCount", notifications.size()));
    }

    // @GetMapping("/tasker/{taskerId}")
    // public ResponseEntity<?> getTaskerNotifications(
    // @PathVariable Integer taskerId,
    // @RequestParam(defaultValue = "SENT") NotificationStatus status) {
    // List<TaskerNotification> notifications =
    // notificationService.getNotificationsByTaskerAndStatus(taskerId,
    // status);
    // return ResponseEntity.ok(notifications);
    // }

    // @PatchMapping("/{notificationId}/status")
    // public ResponseEntity<?> updateNotificationStatus(
    // @PathVariable Long notificationId,
    // @RequestParam NotificationStatus status) {
    // TaskerNotification notification =
    // notificationService.updateNotificationStatus(notificationId, status);
    // return ResponseEntity.ok(notification);
    // }
}
