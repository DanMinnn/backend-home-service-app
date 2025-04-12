package com.danmin.home_service.service.impl;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.danmin.home_service.common.TokenType;
import com.danmin.home_service.dto.request.SignInRequest;
import com.danmin.home_service.dto.response.TokenResponse;
import com.danmin.home_service.service.AuthenticationService;
import com.danmin.home_service.service.JwtService;
import com.danmin.home_service.service.UserTypeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "AUTHENTICATION-SERVICE")
public class AuthenticationServiceImpl implements AuthenticationService {

    private final UserTypeService userTypeService;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    @Override
    public TokenResponse getAccessToken(SignInRequest request) {

        try {
            // check if user exists in the database
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));

            SecurityContextHolder.getContext().setAuthentication(authentication);

        } catch (AuthenticationException e) {
            log.error("Login failed for user: {}", request.getEmail(), e);
            throw new AccessDeniedException(e.getMessage());
        }

        // var user = userDetailService.loadUserByUsername(request.getEmail());

        var user = userTypeService.findByEmail(request.getEmail())
                .orElseThrow(() -> new AccessDeniedException("User not found with username: " + request.getEmail()));

        // check if authentication is successful
        String accessToken = jwtService.generateAccessToken(user.getId(), request.getEmail(), user.getAuthorities());
        String refreshToken = jwtService.generateRefreshToken(user.getId(), request.getEmail(), user.getAuthorities());

        return TokenResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    @Override
    public TokenResponse getRefreshToken(String request) {
        log.info("Request refresh token");

        // check if refresh token is valid
        if (request == null || request.isEmpty()) {
            throw new AccessDeniedException("Refresh token is missing");
        }

        String email = jwtService.extractEmail(request, TokenType.REFRESH_TOKEN);
        if (email == null || email.isEmpty()) {
            throw new AccessDeniedException("Invalid refresh token");
        }

        // check if user exists in the database
        var user = userTypeService.findByEmail(email)
                .orElseThrow(() -> new AccessDeniedException("User not found with email: " + email));

        // check if refresh token is valid
        if (!jwtService.isValid(request, TokenType.REFRESH_TOKEN, user)) {
            throw new AccessDeniedException("Invalid refresh token");
        }

        // check if authentication is successful
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail(), user.getAuthorities());

        String refreshToken = jwtService.generateRefreshToken(user.getId(), user.getEmail(), user.getAuthorities());

        return TokenResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

}
