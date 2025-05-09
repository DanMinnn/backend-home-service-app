package com.danmin.home_service.dto.request;

import java.io.Serializable;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;

@Getter
public class ServiceDTO implements Serializable {

    @NotNull(message = "Category name can not be empty")
    private String name;
    private String des;
    private Boolean isActive;
}
