package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.service.PaymentService;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@Slf4j(topic = "PAYMENT-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Payment Controller")
@RequestMapping("/payment")
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping("/create-payment/{bookingId}")
    public ResponseData<Map<String, String>> createPayment(
            @PathVariable(value = "bookingId") long bookingId,
            HttpServletRequest request) throws UnsupportedEncodingException {

        String paymentUrl = paymentService.createPaymentUrl(request, bookingId);

        Map<String, String> response = new HashMap<>();
        response.put("paymentUrl", paymentUrl);

        return new ResponseData(HttpStatus.ACCEPTED.value(), "Payment successfully", response);
    }

    @GetMapping("/vnpay_return")
    public ResponseData<?> vnpayReturn(
            @RequestParam(value = "bookingId") long bookingId,
            HttpServletRequest request) throws UnsupportedEncodingException {

        Map<String, String> response = new HashMap<>();

        String vnpResponseCode = request.getParameter("vnp_ResponseCode");
        String vnpTxnRef = request.getParameter("vnp_TxnRef");

        paymentService.updatePaymentStatus(vnpTxnRef, vnpResponseCode, bookingId);

        if ("00".equals(vnpResponseCode)) {
            return new ResponseData(HttpStatus.ACCEPTED.value(), "Payment successfully", response);
        } else {
            return new ResponseData(HttpStatus.BAD_REQUEST.value(), "Payment failed with code", vnpResponseCode);
        }

    }

}
