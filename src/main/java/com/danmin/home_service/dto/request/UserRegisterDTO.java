package com.danmin.home_service.dto.request;

import java.io.Serializable;

import com.danmin.home_service.common.UserType;
import com.danmin.home_service.dto.validator.EnumPattern;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRegisterDTO extends RegisterDTO implements Serializable {

    @NotNull(message = "type must be not null")
    @EnumPattern(name = "status", regexp = "customer|admin")
    private UserType type;
}
