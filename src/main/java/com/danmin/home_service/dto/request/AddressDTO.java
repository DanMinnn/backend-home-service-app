package com.danmin.home_service.dto.request;

import java.io.Serializable;
import java.math.BigDecimal;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AddressDTO implements Serializable {

    @NotNull(message = "Address can not be empty")
    private String addressName;

    private String apartmentType;

    @NotNull(message = "House number can not be empty")
    private String houseNumber;

    private BigDecimal longitude;

    private BigDecimal latitude;

    private boolean isDefault;
}
