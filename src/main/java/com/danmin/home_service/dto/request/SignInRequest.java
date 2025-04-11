package com.danmin.home_service.dto.request;

import java.io.Serializable;

import lombok.Getter;

@Getter
public class SignInRequest implements Serializable {
    private String email;
    private String password;
    private String platform;
    private String deviceToken; // push notification for each device based on device
}
