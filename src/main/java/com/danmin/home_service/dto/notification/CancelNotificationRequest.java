package com.danmin.home_service.dto.notification;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CancelNotificationRequest implements Serializable {
    private String reason;
    private String cancelledBy;
}
