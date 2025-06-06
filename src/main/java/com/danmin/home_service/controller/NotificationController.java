package com.danmin.home_service.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.danmin.home_service.dto.notification.FCMTokenRequest;
import com.danmin.home_service.dto.notification.TaskerNotificationResponse;
import com.danmin.home_service.dto.notification.UserNotificationResponse;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.model.FCMToken;
import com.danmin.home_service.service.FirebaseNotificationService;
import com.danmin.home_service.service.NotificationService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j(topic = "NOTIFICATION-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Notification Controller")
@RequestMapping("/notifications")
public class NotificationController {
    private final NotificationService notificationService;
    private final FirebaseNotificationService firebaseNotificationService;

    @Operation(summary = "Register FCM token for user or tasker")
    @PostMapping("/fcm/register")
    public ResponseData<?> registerFCMToken(@Valid @RequestBody FCMTokenRequest request) {
        FCMToken token = FCMToken.builder()
                .token(request.getToken())
                .userId(request.getUserId())
                .taskerId(request.getTaskerId())
                .deviceId(request.getDeviceId())
                .build();

        firebaseNotificationService.saveToken(token);
        return new ResponseData(HttpStatus.OK.value(), "FCM token registered successfully");
    }

    // =================== USER ENDPOINTS ===================
    @Operation(summary = "Get notifications for user")
    @GetMapping("/users/{userId}")
    public ResponseData<List<UserNotificationResponse>> getUserNotifications(@PathVariable Long userId) {
        List<UserNotificationResponse> notifications = notificationService.getUserNotifications(userId);
        return new ResponseData(HttpStatus.OK.value(), "User notifications retrieved successfully", notifications);
    }

    @Operation(summary = "Get unread count for user")
    @GetMapping("/users/{userId}/unread-count")
    public ResponseData<Integer> getUserUnreadCount(@PathVariable Long userId) {
        int count = notificationService.getUserUnreadCount(userId);
        return new ResponseData(HttpStatus.OK.value(), "Unread count retrieved", count);
    }

    @Operation(summary = "Mark user notification as read")
    @PutMapping("/users/{notificationId}/read")
    public ResponseData<?> markUserNotificationAsRead(@PathVariable Long notificationId) {
        notificationService.markUserNotificationAsRead(notificationId);
        return new ResponseData(HttpStatus.OK.value(), "Notification marked as read");
    }

    @Operation(summary = "Delete user notifications")
    @DeleteMapping("/delete/{notificationId}")
    public ResponseData<?> clearUserNotifications(@PathVariable Long notificationId) {
        notificationService.deletedUserNotifications(notificationId);
        return new ResponseData(HttpStatus.OK.value(), "Deleted user notifications");
    }

    // =================== TASKER ENDPOINTS ===================
    @Operation(summary = "Get notifications for tasker")
    @GetMapping("/taskers/{taskerId}")
    public ResponseData<List<TaskerNotificationResponse>> getTaskerNotifications(@PathVariable Long taskerId) {
        List<TaskerNotificationResponse> notifications = notificationService.getTaskerNotifications(taskerId);
        return new ResponseData(HttpStatus.OK.value(), "Tasker notifications retrieved successfully", notifications);
    }

    @Operation(summary = "Get unread count for tasker")
    @GetMapping("/taskers/{taskerId}/unread-count")
    public ResponseData<Integer> getTaskerUnreadCount(@PathVariable Long taskerId) {
        int count = notificationService.getTaskerUnreadCount(taskerId);
        return new ResponseData(HttpStatus.OK.value(), "Unread count retrieved", count);
    }

    @Operation(summary = "Mark tasker notification as read")
    @PutMapping("/taskers/{notificationId}/read")
    public ResponseData<?> markTaskerNotificationAsRead(@PathVariable Long notificationId) {
        notificationService.markTaskerNotificationAsRead(notificationId);
        return new ResponseData(HttpStatus.OK.value(), "Notification marked as read");
    }

    @Operation(summary = "Delete tasker notifications")
    @DeleteMapping("/delete/{notificationId}")
    public ResponseData<?> clearTaskerNotifications(@PathVariable Long notificationId) {
        notificationService.clearTaskerNotifications(notificationId);
        return new ResponseData(HttpStatus.OK.value(), "Deleteted tasker notifications");
    }

    // =================== CHAT NOTIFICATION ENDPOINTS ===================
    @Operation(summary = "Get unread chat message count for user")
    @GetMapping("/users/{userId}/chat/unread-count")
    public ResponseData<Map<String, Object>> getUserChatUnreadCount(@PathVariable Long userId) {
        Map<String, Object> result = notificationService.getUserChatUnreadCount(userId);
        return new ResponseData(HttpStatus.OK.value(), "Chat unread count retrieved",
                result);
    }

    @Operation(summary = "Get unread chat message count for tasker")
    @GetMapping("/taskers/{taskerId}/chat/unread-count")
    public ResponseData<Map<String, Object>> getTaskerChatUnreadCount(@PathVariable Long taskerId) {
        Map<String, Object> result = notificationService.getTaskerChatUnreadCount(taskerId);
        return new ResponseData(HttpStatus.OK.value(), "Chat unread count retrieved",
                result);
    }
}
