package com.danmin.home_service.dto.response;

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
public class UserResponse implements Serializable {

    private Integer id;
    private String firstLastName;
    private String phoneNumber;
    private String email;
    private String profileImage;
    private boolean isActive;
    private String taskerStatus;
    private LocalDateTime lastLogin;
}
