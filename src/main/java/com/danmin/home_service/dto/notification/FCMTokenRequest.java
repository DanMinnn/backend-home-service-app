package com.danmin.home_service.dto.notification;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class FCMTokenRequest {
    @NotBlank(message = "FCM token is required")
    private String token;

    private Integer userId;

    private Integer taskerId;

    private String deviceId;
}
