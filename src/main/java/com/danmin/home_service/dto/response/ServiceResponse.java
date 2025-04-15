package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.util.Set;

import com.danmin.home_service.model.Services;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class ServiceResponse implements Serializable {

    private Integer id;
    private String name;
    private boolean isActive;
    private Set<Services> services;

}
