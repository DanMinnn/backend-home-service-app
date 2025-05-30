package com.danmin.home_service.dto.notification;

import java.io.Serializable;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
@AllArgsConstructor
public class FCMNotificationResponse implements Serializable {
    private String title;
    private String body;
    private Map<String, String> data;
    private String topic;
    private String token;
}
