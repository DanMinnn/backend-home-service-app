package com.danmin.home_service.dto.request;

import java.time.LocalDateTime;

import com.danmin.home_service.common.SenderType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatNotificationDTO {
    private Integer roomId;
    private Integer messageId;
    private Integer senderId;
    private SenderType senderType;
    private String senderName;
    private String messageText;
    private LocalDateTime timestamp;
}
