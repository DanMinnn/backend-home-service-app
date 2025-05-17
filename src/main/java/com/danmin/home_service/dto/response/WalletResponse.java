package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class WalletResponse implements Serializable {

    Integer userId;
    Integer walletId;
    BigDecimal balance;
    private Set<UserTransactionResponse> transactions;
}
