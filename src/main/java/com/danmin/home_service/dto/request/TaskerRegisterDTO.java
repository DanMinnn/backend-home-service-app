package com.danmin.home_service.dto.request;

import java.io.Serializable;
import java.math.BigDecimal;

import com.danmin.home_service.common.AvailabilityStatus;
import com.danmin.home_service.dto.validator.EnumPattern;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TaskerRegisterDTO implements Serializable {

    @NotNull(message = "Firstname and lastname must be not blank")
    private String firstLastName;

    @Pattern(regexp = "^\\d{10}$", message = "Phone number invalid format")
    private String phoneNumber;

    @Email(message = "Email invalid format")
    private String email;

    @NotNull(message = "Password must be not null")
    private String password;

    private boolean isVerify;

    private BigDecimal longitude;

    private BigDecimal latitude;

    private Double average_rating;

    private Double total_earnings;

    @NotNull(message = "type must be not null")
    @EnumPattern(name = "status", regexp = "available|busy|offline")
    private AvailabilityStatus status;
}
