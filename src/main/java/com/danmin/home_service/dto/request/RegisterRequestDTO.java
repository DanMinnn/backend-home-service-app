package com.danmin.home_service.dto.request;

import java.io.Serializable;

import com.danmin.home_service.common.UserType;
import com.danmin.home_service.dto.validator.EnumPattern;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequestDTO implements Serializable {

    @NotNull(message = "Firstname must be not blank")
    private String firstName;

    @NotNull(message = "Lastname must be not blank")
    private String lastName;

    @Pattern(regexp = "^\\d{10}$", message = "Phone number invalid format")
    private String phoneNumber;

    @Email(message = "Email invalid format")
    private String email;

    @NotNull(message = "Password must be not null")
    private String password;

    private boolean isVerify;

    @NotNull(message = "type must be not null")
    @EnumPattern(name = "status", regexp = "customer|tasker|admin")
    private UserType type;
}
