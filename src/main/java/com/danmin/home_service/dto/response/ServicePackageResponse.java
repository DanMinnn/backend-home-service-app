package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class ServicePackageResponse implements Serializable {

    private Long id;
    private String name;
    private boolean isActive;
    private Set<PackageResponse> servicePackages;
}
