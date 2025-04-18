package com.danmin.home_service.dto.request;

import java.time.LocalDateTime;

import com.danmin.home_service.common.SenderType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
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
}
