package com.danmin.home_service.dto.request;

import com.danmin.home_service.common.SenderType;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ChatNotificationDTO {
    private Integer roomId;
    private Integer messageId;
    private Integer senderId;
    private SenderType senderType;
    private String senderName;
    private String messageText;
}
