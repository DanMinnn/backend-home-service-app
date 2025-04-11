package com.danmin.home_service.service.impl;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.request.SignInRequest;
import com.danmin.home_service.dto.response.TokenResponse;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.AuthenticationService;
import com.danmin.home_service.service.JwtService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "AUTHENTICATION-SERVICE")
public class AuthenticationServiceImpl implements AuthenticationService {

    private final UserRepository userRepository;
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

        var user = userRepository.findByEmail(request.getEmail());

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
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getRefreshToken'");
    }

}
