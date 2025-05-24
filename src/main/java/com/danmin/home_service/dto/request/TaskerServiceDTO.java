package com.danmin.home_service.dto.request;

import java.io.Serializable;
import java.util.Set;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TaskerServiceDTO implements Serializable {
    Long taskerId;
    Set<Long> serviceIds;
}
