package com.danmin.home_service.dto.request;

import java.io.Serializable;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDTO implements Serializable {

    @NotNull(message = "This field is not empty")
    private String firstLastName;

    private String profileImage;

    private String address;
}
