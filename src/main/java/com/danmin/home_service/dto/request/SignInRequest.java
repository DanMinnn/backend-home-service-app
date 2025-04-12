package com.danmin.home_service.dto.request;

import java.io.Serializable;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;

@Getter
public class SignInRequest implements Serializable {

    @NotNull(message = "Email is required")
    private String email;
    @NotNull(message = "Password is required")
    private String password;
    private String platform;
    private String deviceToken; // push notification for each device based on device
}
