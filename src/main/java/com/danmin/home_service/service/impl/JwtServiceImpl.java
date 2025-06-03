package com.danmin.home_service.service.impl;

import java.security.Key;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.danmin.home_service.common.TokenType;
import com.danmin.home_service.exception.InvalidDataException;
import com.danmin.home_service.service.JwtService;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j(topic = "JWT-SERVICE")
public class JwtServiceImpl implements JwtService {

    @Value("${jwt.access-key}")
    private String accessKey;

    @Value("${jwt.expiration}")
    private long expiredTime;

    @Value("${jwt.refresh-token}")
    private String refreshToken;

    @Value("${jwt.reset-key}")
    private String resetKey;

    @Override
    public String generateAccessToken(long userId, String email, Collection<? extends GrantedAuthority> authorities) {
        // log.info("Generating access token for userId: {} with authorities: {}",
        // userId, authorities);

        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("roles", authorities);

        return generateAccessToken(claims, email);
    }

    @Override
    public String generateRefreshToken(long userId, String email, Collection<? extends GrantedAuthority> authorities) {
        // log.info("Generating refresh token for userId: {} with authorities: {}",
        // userId, authorities);

        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("roles", authorities);

        return generateRefreshToken(claims, email);
    }

    @Override
    public String generateResetToken(UserDetails user) {
        return generateResetToken(new HashMap<>(), user);
    }

    @Override
    public String extractEmail(String token, TokenType tokenType) {
        // log.info("Extracting email from token: {} of type: {}",token, tokenType);

        return extractClaim(token, Claims::getSubject, tokenType);
    }

    @Override
    public Integer extractUserId(String token, TokenType tokenType) {
        // log.info("Extracting userId from token: {} of type: {}",token, tokenType);

        return extractClaim(token, claims -> {
            Object userIdObj = claims.get("userId");
            if (userIdObj instanceof Integer) {
                return (Integer) userIdObj;
            } else if (userIdObj instanceof Number) {
                return ((Number) userIdObj).intValue();
            } else {
                return Integer.valueOf(userIdObj.toString());
            }
        }, tokenType);
    }

    private <T> T extractClaim(String token, Function<Claims, T> claimsResolver, TokenType tokenType) {
        // log.info("Extracting claim from token: {} of type: {}", token, tokenType);

        final Claims claims = extractAllClaims(token, tokenType);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token, TokenType tokenType) {
        try {
            return Jwts.parser().setSigningKey(getKey(tokenType)).build().parseClaimsJws(token).getBody();
        } catch (ExpiredJwtException e) {
            throw e;
        } catch (Exception e) {
            throw new InvalidDataException("Invalid token: " + e.getMessage(), e);
        }
    }

    private String generateAccessToken(Map<String, Object> claims, String email) {
        // log.info("Generate access token for user {} with email", email, claims);

        return Jwts.builder()
                .claims(claims)
                .subject(email)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24)) // 1 day
                .signWith(getKey(TokenType.ACCESS_TOKEN), SignatureAlgorithm.HS256)
                .compact();
    }

    private String generateRefreshToken(Map<String, Object> claims, String email) {
        // log.info("Generate refresh token for user {} with email", email, claims);

        return Jwts.builder()
                .claims(claims)
                .subject(email)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 * expiredTime)) // 10 days
                .signWith(getKey(TokenType.REFRESH_TOKEN), SignatureAlgorithm.HS256)
                .compact();
    }

    public String generateResetToken(Map<String, Object> claims, UserDetails user) {
        // log.info("Generate reset token for user {} with email", user.getUsername(),
        // claims);

        return Jwts.builder()
                .claims(claims)
                .subject(user.getUsername())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + 1000 * 60 * 5)) // 5 mins
                .signWith(getKey(TokenType.RESET_TOKEN), SignatureAlgorithm.HS256)
                .compact();
    }

    private Key getKey(TokenType tokenType) {

        switch (tokenType) {
            case ACCESS_TOKEN -> {
                return Keys.hmacShaKeyFor(Decoders.BASE64.decode(accessKey));
            }
            case REFRESH_TOKEN -> {
                return Keys.hmacShaKeyFor(Decoders.BASE64.decode(refreshToken));
            }
            case RESET_TOKEN -> {
                return Keys.hmacShaKeyFor(Decoders.BASE64.decode(resetKey));
            }
            default -> throw new InvalidDataException("Invalid token type: " + tokenType);
        }
    }

    @Override
    public Boolean isValid(String token, TokenType tokenType, UserDetails userDetails) {
        final String email = extractEmail(token, tokenType);
        return (email.equals(userDetails.getUsername()) && !isTokenExpired(token, tokenType));
    }

    private Boolean isTokenExpired(String token, TokenType tokenType) {
        return extractExpiration(token, tokenType).before(new Date());
    }

    private Date extractExpiration(String token, TokenType tokenType) {
        return extractClaim(token, Claims::getExpiration, tokenType);
    }

}
