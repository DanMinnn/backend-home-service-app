package com.danmin.home_service.service;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.danmin.home_service.common.TokenType;

public interface JwtService {
    String generateAccessToken(long userId, String email, Collection<? extends GrantedAuthority> authorities);

    String generateRefreshToken(long userId, String email, Collection<? extends GrantedAuthority> authorities);

    String extractEmail(String token, TokenType tokenType);

    Integer extractUserId(String token, TokenType tokenType);

    Boolean isValid(String token, TokenType tokenType, UserDetails userDetails);

    String generateResetToken(UserDetails user);
}
