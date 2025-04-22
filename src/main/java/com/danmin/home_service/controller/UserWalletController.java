package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.UserWalletService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;

@RestController
@Slf4j(topic = "USER-WALLET-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "User Wallet Controller")
@RequestMapping("/wallet")
public class UserWalletController {

    private final UserWalletService userWalletService;

    @Operation(summary = "Recharge money into wallet user")
    @PostMapping("/recharge")
    public ResponseData<?> recharge(@RequestParam(value = "userId") long userId,
            @RequestParam(value = "amount") BigDecimal amount) {

        try {
            String status = userWalletService.rechargeIntoWallet(userId, amount);

            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Recharge", status);
        } catch (Exception e) {

            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @Operation(summary = "Deduct money to wallet user")
    @PostMapping("/deduct")
    public ResponseData<?> deduct(@RequestParam(value = "userId") long userId,
            @RequestParam(value = "amount") BigDecimal amount) {

        try {
            userWalletService.debitAccount(userId, amount);

            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Deduct successfully");
        } catch (Exception e) {

            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

}
