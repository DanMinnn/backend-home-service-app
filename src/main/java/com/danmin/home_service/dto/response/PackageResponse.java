package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class PackageResponse implements Serializable {

    private Long id;
    private String name;
    private String description;
    private BigDecimal basePrice;
    private Set<PackageVariantsResponse> variants;
}
