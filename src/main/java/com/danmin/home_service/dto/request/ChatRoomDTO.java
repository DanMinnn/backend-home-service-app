package com.danmin.home_service.dto.request;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ChatRoomDTO {
    private Integer id;
    private Long bookingId;
    private Integer userId;
    private Integer taskerId;
    private String userName;
    private String taskerName;
    private String userProfile;
    private String taskerProfile;
    private LocalDateTime lastMessageAt;
    private ChatMessageDTO lastMessage;
}
