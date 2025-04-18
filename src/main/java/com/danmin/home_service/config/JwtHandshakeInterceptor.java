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
import com.danmin.home_service.repository.TaskerNotificationRepository;
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

    private final TaskerNotificationRepository taskerNotificationRepository;

    private final JwtService jwtService;

    @Value("${jwt.access-key}")
    private String accessKey;

    @Override
    public void afterHandshake(ServerHttpRequest arg0, ServerHttpResponse arg1, WebSocketHandler arg2, Exception arg3) {

    }

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
            Map<String, Object> attributes) throws Exception {

        if (request instanceof ServletServerHttpRequest servletRequest) {
            HttpServletRequest httpRequest = servletRequest.getServletRequest();

            String token = httpRequest.getParameter("token");
            if (token != null && !token.isEmpty()) {
                try {
                    String email = jwtService.extractEmail(token, TokenType.ACCESS_TOKEN);
                    Claims claims = Jwts.parser()
                            .setSigningKey(Keys.hmacShaKeyFor(Decoders.BASE64.decode(accessKey)))
                            .build()
                            .parseClaimsJws(token)
                            .getBody();

                    Long userId = claims.get("userId", Integer.class).longValue();
                    List<Map<String, String>> authoritiesList = (List<Map<String, String>>) claims.get("roles");
                    List<String> roles = authoritiesList.stream()
                            .map(map -> map.get("authority"))
                            .collect(Collectors.toList());

                    attributes.put("userId", userId);
                    attributes.put("email", email);
                    attributes.put("roles", roles);

                    // check token expiration
                    Date expirationDate = claims.getExpiration();
                    if (expirationDate.before(new Date())) {
                        log.error("Token expired");
                        response.setStatusCode(HttpStatus.UNAUTHORIZED);
                        return false;
                    }

                    return true;
                } catch (Exception e) {
                    log.error("Invalid JWT token = {} ", e.getMessage());
                }
            }
        }
        response.setStatusCode(HttpStatus.UNAUTHORIZED);
        return false;
    }

}
