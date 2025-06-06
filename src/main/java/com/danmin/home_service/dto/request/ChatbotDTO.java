package com.danmin.home_service.dto.request;

import java.io.Serializable;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class ChatbotDTO implements Serializable {
    Integer userId;
    String query;
    String response;
    LocalDateTime sentAt;
}
