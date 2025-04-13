package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.ChangePasswordDTO;
import com.danmin.home_service.dto.request.SignInRequest;
import com.danmin.home_service.dto.response.TokenResponse;
import com.danmin.home_service.service.AuthenticationService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.web.bind.annotation.GetMapping;
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
    public TokenResponse getAccessToken(@Valid @RequestBody SignInRequest request) {
        log.info("Request get access token {}", request.getEmail());
        return authenticationService.getAccessToken(request);
    }

    @Operation(summary = "Refresh token", description = "Get new access token by refresh token")
    @PostMapping("/refresh-token")
    public TokenResponse getRefreshToken(@Valid @RequestBody String refreshToken) {
        log.info("Request refresh token");
        return authenticationService.getRefreshToken(refreshToken);
    }

    @Operation(summary = "Forgot password")
    @PostMapping("/forgot-password")
    public String forgotPassword(@Valid @RequestBody String email) {
        log.info("Request forgot password for user with email {}", email);
        return authenticationService.forgotPassword(email);
    }

    @Operation(summary = "Confirm reset password", description = "Verify token when click confirm reset password")
    @GetMapping("/reset-password")
    public String resetPassword(@RequestParam String data) {
        log.info("Confirm reset password ");
        return authenticationService.resetPassword(data);
    }

    @Operation(summary = "Change password", description = "Change password for user")
    @PostMapping("/change-password")
    public String changePassword(@Valid @RequestBody ChangePasswordDTO req) {
        log.info("Confirm reset password ");
        return authenticationService.changePassword(req);
    }

}
