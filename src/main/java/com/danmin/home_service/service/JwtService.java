package com.danmin.home_service.service;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;

import com.danmin.home_service.common.TokenType;

public interface JwtService {
    String generateAccessToken(long userId, String email, Collection<? extends GrantedAuthority> authorities);

    String generateRefreshToken(long userId, String email, Collection<? extends GrantedAuthority> authorities);

    String extractEmail(String token, TokenType tokenType);
}
