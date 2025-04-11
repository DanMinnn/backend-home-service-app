package com.danmin.home_service.dto.request;

import java.io.Serializable;
import java.math.BigDecimal;

import com.danmin.home_service.common.AvailabilityStatus;
import com.danmin.home_service.dto.validator.EnumPattern;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TaskerRegisterDTO extends RegisterDTO implements Serializable {

    private BigDecimal longitude;

    private BigDecimal latitude;

    private Double average_rating;

    private Double total_earnings;

    @NotNull(message = "type must be not null")
    @EnumPattern(name = "status", regexp = "available|busy|offline")
    private AvailabilityStatus status;
}
