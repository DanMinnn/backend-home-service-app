package com.danmin.home_service.config;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import com.danmin.home_service.common.TokenType;
import com.danmin.home_service.service.JwtService;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtHandshakeInterceptor implements HandshakeInterceptor {

    private final JwtService jwtService;

    @Value("${jwt.access-key}")
    private String accessKey;

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
            Exception exception) {
        if (exception != null) {
            log.error("WebSocket handshake failed", exception);
        } else {
            log.info("WebSocket handshake completed successfully");
        }
    }

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
            Map<String, Object> attributes) throws Exception {

        log.info("WebSocket handshake starting for request: {}", request.getURI());

        if (request instanceof ServletServerHttpRequest servletRequest) {
            HttpServletRequest httpRequest = servletRequest.getServletRequest();

            // Try to get token from multiple sources
            String token = extractToken(httpRequest);

            if (token != null && !token.isEmpty()) {
                log.debug("Token found for handshake, length: {}", token.length());
                try {
                    // Validate token and extract user info
                    String email = jwtService.extractEmail(token, TokenType.ACCESS_TOKEN);
                    if (email == null || email.isEmpty()) {
                        log.error("Email not found in JWT token");
                        response.setStatusCode(HttpStatus.UNAUTHORIZED);
                        return false;
                    }
                    log.debug("Email extracted from token: {}", email);

                    Claims claims = Jwts.parser()
                            .setSigningKey(Keys.hmacShaKeyFor(Decoders.BASE64.decode(accessKey)))
                            .build()
                            .parseClaimsJws(token)
                            .getBody();

                    log.debug("JWT claims parsed successfully");

                    // Check token expiration first
                    Date expirationDate = claims.getExpiration();
                    if (expirationDate.before(new Date())) {
                        log.error("Token expired for email: {}", email);
                        response.setStatusCode(HttpStatus.UNAUTHORIZED);
                        return false;
                    }

                    // Extract user information with proper type handling
                    Object userIdObj = claims.get("userId");
                    log.debug("Raw userId from claims: {} (type: {})", userIdObj,
                            userIdObj != null ? userIdObj.getClass() : "null");

                    Long userId = null;

                    if (userIdObj instanceof Integer) {
                        userId = ((Integer) userIdObj).longValue();
                    } else if (userIdObj instanceof Long) {
                        userId = (Long) userIdObj;
                    } else if (userIdObj instanceof String) {
                        try {
                            userId = Long.parseLong((String) userIdObj);
                        } catch (NumberFormatException e) {
                            log.error("Invalid userId format in token: {}", userIdObj);
                            response.setStatusCode(HttpStatus.UNAUTHORIZED);
                            return false;
                        }
                    } else {
                        log.error("Invalid userId type in token: {}",
                                userIdObj != null ? userIdObj.getClass() : "null");
                        response.setStatusCode(HttpStatus.UNAUTHORIZED);
                        return false;
                    }

                    log.debug("UserId successfully extracted: {}", userId);

                    // Extract roles with proper null checking
                    List<String> roles = extractRoles(claims);
                    log.debug("Roles extracted: {}", roles);

                    // Set session attributes - these will be available in WebSocket handlers
                    attributes.put("userId", userId);
                    attributes.put("email", email);
                    attributes.put("roles", roles);
                    attributes.put("token", token);
                    attributes.put("authenticated", true);

                    log.info("WebSocket handshake authentication successful for user: {} with email: {} and roles: {}",
                            userId, email, roles);

                    // Verify attributes were actually set
                    log.debug("Session attributes set during handshake: {}", attributes.keySet());
                    log.debug("UserId in attributes: {}", attributes.get("userId"));

                    return true;

                } catch (Exception e) {
                    log.error("JWT token validation failed during WebSocket handshake: {}", e.getMessage(), e);
                    response.setStatusCode(HttpStatus.UNAUTHORIZED);
                    return false;
                }
            } else {
                log.warn("No token provided in WebSocket handshake - checking all sources");
                logRequestDetails(httpRequest);
            }
        } else {
            log.error("Request is not a ServletServerHttpRequest: {}", request.getClass());
        }

        log.error("WebSocket handshake failed - returning false");
        response.setStatusCode(HttpStatus.UNAUTHORIZED);
        return false;
    }

    private String extractToken(HttpServletRequest request) {
        // Try query parameter first (most common for WebSocket connections)
        String token = request.getParameter("token");
        if (token != null && !token.isEmpty()) {
            log.debug("Token found in query parameter 'token'");
            return token;
        }

        // Try 'access_token' parameter (alternative)
        token = request.getParameter("access_token");
        if (token != null && !token.isEmpty()) {
            log.debug("Token found in query parameter 'access_token'");
            return token;
        }

        // Try Authorization header
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
            log.debug("Token found in Authorization header");
            return token;
        }

        // Try other common headers
        token = request.getHeader("X-Auth-Token");
        if (token != null && !token.isEmpty()) {
            log.debug("Token found in X-Auth-Token header");
            return token;
        }

        log.warn("No token found in any expected location");
        return null;
    }

    private void logRequestDetails(HttpServletRequest request) {
        log.debug("Request URI: {}", request.getRequestURI());
        log.debug("Query String: {}", request.getQueryString());

        log.debug("Available headers:");
        request.getHeaderNames().asIterator()
                .forEachRemaining(header -> log.debug("  Header {}: {}", header, request.getHeader(header)));

        log.debug("Available parameters:");
        request.getParameterMap()
                .forEach((key, values) -> log.debug("  Parameter {}: {}", key, String.join(",", values)));
    }

    private List<String> extractRoles(Claims claims) {
        try {
            Object rolesObj = claims.get("roles");
            if (rolesObj instanceof List) {
                List<?> rolesList = (List<?>) rolesObj;
                if (!rolesList.isEmpty() && rolesList.get(0) instanceof Map) {
                    // Format: [{"authority": "ROLE_USER"}, {"authority": "ROLE_TASKER"}]
                    return rolesList.stream()
                            .filter(item -> item instanceof Map)
                            .map(item -> {
                                Map<?, ?> roleMap = (Map<?, ?>) item;
                                Object authority = roleMap.get("authority");
                                return authority != null ? authority.toString() : null;
                            })
                            .filter(role -> role != null)
                            .collect(Collectors.toList());
                } else {
                    // Format: ["ROLE_USER", "ROLE_TASKER"]
                    return rolesList.stream()
                            .filter(item -> item != null)
                            .map(Object::toString)
                            .collect(Collectors.toList());
                }
            }
        } catch (Exception e) {
            log.warn("Error extracting roles from token: {}", e.getMessage());
        }

        return List.of(); // Return empty list if no roles found
    }
}
