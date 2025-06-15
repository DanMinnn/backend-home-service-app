package com.danmin.home_service.dto.request;

import java.math.BigDecimal;

import lombok.Getter;

@Getter
public class PackageDTO {
    String packageName;
    String packageDescription;
    BigDecimal packagePrice;
}
