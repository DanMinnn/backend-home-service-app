package com.danmin.home_service.dto.request;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RechargeDTO implements Serializable {
    private Long userId;
    private BigDecimal amount;
}
