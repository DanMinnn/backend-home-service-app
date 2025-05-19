package com.danmin.home_service.dto.request;

import java.io.Serializable;

import com.danmin.home_service.common.AvailabilityStatus;
import com.danmin.home_service.dto.validator.EnumPattern;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TaskerRegisterDTO extends RegisterDTO implements Serializable {

    @NotNull(message = "type must be not null")
    @EnumPattern(name = "status", regexp = "available|busy|offline")
    private AvailabilityStatus status;
}
