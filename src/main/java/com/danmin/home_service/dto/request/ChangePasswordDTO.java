package com.danmin.home_service.dto.request;

import lombok.Getter;

@Getter
public class ChangePasswordDTO {
    private String secretKey;
    private String password;
    private String confirmPassword;
}
