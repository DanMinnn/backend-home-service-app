package com.danmin.home_service.service.impl;

import java.io.IOException;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.danmin.home_service.common.TokenType;
import com.danmin.home_service.dto.request.ChangePasswordDTO;
import com.danmin.home_service.dto.request.SignInRequest;
import com.danmin.home_service.dto.response.TokenResponse;
import com.danmin.home_service.exception.InvalidDataException;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.AuthenticationService;
import com.danmin.home_service.service.EmailService;
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
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final TaskerRepository taskerRepository;

    @Transactional
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

        if ("CLIENT".equalsIgnoreCase(request.getPlatform()) && !(user instanceof User)) {
            throw new InvalidDataException("INVALID_USER_TYPE_FOR_CLIENT_APP");
        } else if ("TASKER".equalsIgnoreCase(request.getPlatform()) && !(user instanceof Tasker)) {
            throw new InvalidDataException("INVALID_USER_TYPE_FOR_TASKER_APP");
        }

        // check if authentication is successful
        String accessToken = jwtService.generateAccessToken(user.getId(), request.getEmail(), user.getAuthorities());
        String refreshToken = jwtService.generateRefreshToken(user.getId(), request.getEmail(), user.getAuthorities());

        return TokenResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(600)
                .isNew(true)
                .hasUsernamePassword(true)
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

    @Override
    public String forgotPassword(String email) {
        // check if user exists in the database
        var user = userTypeService.findByEmail(email)
                .orElseThrow(() -> new AccessDeniedException("User not found with email: " +
                        email));

        // implement...
        if (!user.isEnabled()) {
            throw new InvalidDataException("User is not active");
        }

        // generate reset toke
        String resetToken = jwtService.generateResetToken(user);

        // send email confirm link
        try {
            emailService.sendEmailForgotPassword(email, resetToken);
        } catch (IOException e) {
            log.info("Error send change password link, message={}", e.getMessage());
        }

        return "Password reset link sent. Check your email!";
    }

    @Override
    public String resetPassword(String key) {
        log.info("--------- reset password ---------");

        final String email = jwtService.extractEmail(key, TokenType.RESET_TOKEN);

        var user = userTypeService.findByEmail(email)
                .orElseThrow(() -> new InvalidDataException("USER_NOT_FOUND"));

        if (!jwtService.isValid(key, TokenType.RESET_TOKEN, user)) {
            throw new InvalidDataException("TOKEN_EXPIRED");
        }

        return "Account is verified !";
    }

    @Override
    public String changePassword(ChangePasswordDTO request) {
        log.info("--------- change password ---------");

        final String email = jwtService.extractEmail(request.getSecretKey(), TokenType.RESET_TOKEN);

        if (email == null || email.isEmpty()) {
            throw new InvalidDataException("TOKEN_EXPIRED");
        }

        var user = userTypeService.findByEmail(email)
                .orElseThrow(() -> new InvalidDataException("USER_NOT_FOUND"));

        if (!user.isEnabled()) {
            throw new InvalidDataException("USER_INACTIVE");
        }

        if (!jwtService.isValid(request.getSecretKey(), TokenType.RESET_TOKEN, user)) {
            throw new InvalidDataException("TOKEN_EXPIRED");
        }

        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new InvalidDataException("PASSWORD_MISMATCH");
        }

        if (user instanceof User) {
            User userDefault = (User) user;
            userDefault.setPasswordHash(passwordEncoder.encode(request.getPassword()));
            userRepository.save(userDefault);
        } else if (user instanceof Tasker) {
            Tasker tasker = (Tasker) user;
            tasker.setPasswordHash(passwordEncoder.encode(request.getPassword()));
            taskerRepository.save(tasker);
        }

        return "PASSWORD_CHANGED_SUCCESS";
        // try {

        // } catch (Exception e) {
        // // Log the exception for server-side tracking
        // log.error("Change password failed: {}", e.getMessage());

        // // Re-throw with appropriate message
        // if (e instanceof InvalidDataException) {
        // throw e; // Already has appropriate message
        // } else if (e.getMessage() != null && e.getMessage().contains("JWT expired"))
        // {
        // throw new InvalidDataException("TOKEN_EXPIRED");
        // } else {
        // throw new InvalidDataException("CHANGE_PASSWORD_FAILED");
        // }
        // }
    }

}
