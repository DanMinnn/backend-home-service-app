package com.danmin.home_service.dto.response;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class TaskerServiceResponse implements Serializable {
    long serviceId;
    String serviceName;
    String icon;
}
