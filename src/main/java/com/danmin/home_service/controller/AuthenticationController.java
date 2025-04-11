package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.SignInRequest;
import com.danmin.home_service.dto.response.TokenResponse;
import com.danmin.home_service.service.AuthenticationService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Slf4j(topic = "AUTHENTICATION-CONTROLLER")
@Tag(name = "Authentication Controller")
public class AuthenticationController {

    private final AuthenticationService authenticationService;

    @Operation(summary = "Access token", description = "Get access token and refresh token by email and password")
    @PostMapping("/access-token")
    public TokenResponse getAccessToken(@RequestBody SignInRequest request) {
        log.info("Request get access token {}", request.getEmail());
        // return
        // TokenResponse.builder().accessToken("ACCESS-TOKEN").refreshToken("REFRESH-TOKEN").build();
        return authenticationService.getAccessToken(request);
    }

    @Operation(summary = "Refresh token", description = "Get new access token by refresh token")
    @PostMapping("/refresh-token")
    public TokenResponse getRefreshToken(@RequestBody String refreshToken) {
        log.info("Request refresh token");
        return TokenResponse.builder().accessToken("NEW-ACCESS-TOKEN").refreshToken("NEW-REFRESH-TOKEN").build();
    }

}
