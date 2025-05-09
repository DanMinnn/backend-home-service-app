package com.danmin.home_service.dto.response;

import java.io.Serializable;

import lombok.AllArgsConstructor;

import lombok.Builder;

import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class ServiceResponse implements Serializable {
    private Long id;
    private String name;
    private String description;
    private String icon;
    private Boolean isActive;
}
