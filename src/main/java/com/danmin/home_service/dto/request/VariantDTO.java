package com.danmin.home_service.dto.request;

import java.math.BigDecimal;

import lombok.Getter;

@Getter
public class VariantDTO {
    String variantName;
    String variantDes;
    BigDecimal additionalPrice;
}
