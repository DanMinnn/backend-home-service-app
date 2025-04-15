package com.danmin.home_service.dto.request;

import java.io.Serializable;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ServiceCategoryDTO implements Serializable {

    @NotNull(message = "Category name can not be empty")
    private String categoryName;

    private Boolean isActive;
}
