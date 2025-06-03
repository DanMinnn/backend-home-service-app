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
public class ChatMessageDTO {
    private Integer id;
    private Integer roomId;
    private SenderType senderType;
    private Integer senderId;
    private String messageText;
    private LocalDateTime sentAt;
    private String senderName;
    private String senderImage;
    private boolean read;
}
