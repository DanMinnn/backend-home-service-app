package com.danmin.home_service.dto.notification;

import java.io.Serializable;
import java.time.LocalDateTime;

import com.danmin.home_service.common.NotificationType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class TaskerNotificationResponse implements Serializable {
    private Long id;
    private String title;
    private String message;
    private NotificationType type;
    private Boolean isRead;
    private Long bookingId;
    private LocalDateTime createdAt;
}
