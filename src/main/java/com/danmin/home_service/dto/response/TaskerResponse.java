package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class TaskerResponse implements Serializable {

    private Integer id;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String profileImage;
    private boolean isActive;
    private LocalDateTime lastLogin;
    private Set<ServiceResponse> services;
}