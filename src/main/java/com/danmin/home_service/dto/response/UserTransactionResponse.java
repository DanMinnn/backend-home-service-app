package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor

public class UserTransactionResponse implements Serializable {

    private UUID transactionId;
    private BigDecimal amount;
    private String description;
    private String type;
    private LocalDateTime createdAt;

}
