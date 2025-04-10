package com.danmin.home_service.dto.response.response_data;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserResponse implements Serializable {

    private Integer id;
    private String firstName;
    private String lastName;
    private String phoneNumber;
    private String email;
}
