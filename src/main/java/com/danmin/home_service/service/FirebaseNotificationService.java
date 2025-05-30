package com.danmin.home_service.service;

import com.danmin.home_service.dto.notification.FCMNotificationResponse;
import com.danmin.home_service.model.FCMToken;
import com.danmin.home_service.repository.FCMTokenRepository;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.concurrent.ExecutionException;

@Service
@Slf4j
@RequiredArgsConstructor
public class FirebaseNotificationService {

    private final FCMTokenRepository tokenRepository;

    public void saveToken(FCMToken fcmToken) {
        Optional<FCMToken> existingToken;

        if (fcmToken.getUserId() != null) {
            existingToken = tokenRepository.findByUserId(fcmToken.getUserId());
        } else if (fcmToken.getTaskerId() != null) {
            existingToken = tokenRepository.findByTaskerId(fcmToken.getTaskerId());
        } else if (fcmToken.getDeviceId() != null) {
            existingToken = tokenRepository.findByDeviceId(fcmToken.getDeviceId());
        } else {
            throw new IllegalArgumentException("Either userId, taskerId, or deviceId must be provided");
        }

        existingToken.ifPresent(token -> fcmToken.setId(token.getId()));
        tokenRepository.save(fcmToken);
    }

    public boolean sendNotification(FCMNotificationResponse fcmNotification) {
        try {
            Message message = buildMessage(fcmNotification);
            String response = FirebaseMessaging.getInstance().sendAsync(message).get();
            log.info("Successfully sent notification: {}", response);
            return true;
        } catch (InterruptedException | ExecutionException e) {
            log.error("Failed to send notification", e);
            Thread.currentThread().interrupt();
            return false;
        }
    }

    public boolean sendNotificationToUser(Integer userId, FCMNotificationResponse fcmNotification) {
        Optional<FCMToken> tokenOpt = tokenRepository.findByUserId(userId);
        if (tokenOpt.isEmpty()) {
            log.warn("No FCM token found for user ID: {}", userId);
            return false;
        }

        fcmNotification.setToken(tokenOpt.get().getToken());
        return sendNotification(fcmNotification);
    }

    public boolean sendNotificationToTasker(Integer taskerId, FCMNotificationResponse fcmNotification) {
        Optional<FCMToken> tokenOpt = tokenRepository.findByTaskerId(taskerId);
        if (tokenOpt.isEmpty()) {
            log.warn("No FCM token found for tasker ID: {}", taskerId);
            return false;
        }

        fcmNotification.setToken(tokenOpt.get().getToken());
        return sendNotification(fcmNotification);
    }

    private Message buildMessage(FCMNotificationResponse fcmNotification) {
        Message.Builder messageBuilder = Message.builder();

        if (fcmNotification.getToken() != null) {
            messageBuilder.setToken(fcmNotification.getToken());
        } else if (fcmNotification.getTopic() != null) {
            messageBuilder.setTopic(fcmNotification.getTopic());
        } else {
            throw new IllegalArgumentException("Either token or topic must be provided");
        }

        Notification notification = Notification.builder()
                .setTitle(fcmNotification.getTitle())
                .setBody(fcmNotification.getBody())
                .build();

        messageBuilder.setNotification(notification);

        if (fcmNotification.getData() != null) {
            messageBuilder.putAllData(fcmNotification.getData());
        }

        return messageBuilder.build();
    }
}
