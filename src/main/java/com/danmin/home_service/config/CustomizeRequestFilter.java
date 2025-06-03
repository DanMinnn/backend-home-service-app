package com.danmin.home_service.config;

import java.io.IOException;
import java.util.Collection;
import java.util.Date;
import java.util.regex.Pattern;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.danmin.home_service.common.TokenType;
import com.danmin.home_service.service.JwtService;
import com.danmin.home_service.service.PermissionService;
import com.danmin.home_service.service.UserDetailService;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j(topic = "CUSTOMIZE_REQUEST_FILTER")
@RequiredArgsConstructor
public class CustomizeRequestFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UserDetailService userDetailService;
    private final PermissionService permissionService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        log.info("{} {}", request.getMethod(), request.getRequestURI());

        // get url path when user access
        String requestURI = request.getRequestURI();
        String requestMethod = request.getMethod();

        // check url path is included endpoint public (no authentication required)
        if (isPublicEndpoint(requestURI)) {
            filterChain.doFilter(request, response);
            return;
        }

        // if not in endpoint public, check authentication by token
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            sendUnauthorizedResponse(response, "No valid authorization token found");
            // filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);
        log.info("Token: {}", token.substring(0, Math.min(token.length(), 20)));

        String email = "";
        try {
            email = jwtService.extractEmail(token, TokenType.ACCESS_TOKEN);
            log.info("email: {}", email);
        } catch (AccessDeniedException e) {
            log.error("Access denied: {}", e.getMessage());
            sendErrorResponse(response, e.getMessage());
            return;
        }

        UserDetails userDetails = userDetailService.loadUserByUsername(email);

        // Extract userId from token
        Integer userId = jwtService.extractUserId(token, TokenType.ACCESS_TOKEN);

        // authentication
        SecurityContext securityContext = SecurityContextHolder.createEmptyContext();
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());
        authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

        // Create custom details with userId
        CustomWebAuthenticationDetails customDetails = new CustomWebAuthenticationDetails(request, userId);
        authenticationToken.setDetails(customDetails);
        securityContext.setAuthentication(authenticationToken);
        SecurityContextHolder.setContext(securityContext);

        // check access permission
        if (!hasPermission(userDetails, requestMethod, requestURI)) {
            sendForbiddenResponse(response, "User does not have permission to access this resource");
            return;
        }

        filterChain.doFilter(request, response);
    }

    private boolean isPublicEndpoint(String uri) {
        // List endpoint public
        return uri.startsWith("/auth/") ||
                uri.startsWith("/register/") ||
                uri.startsWith("/public/") ||
                uri.equals("/signin") ||
                uri.equals("/signup");
    }

    private boolean hasPermission(UserDetails userDetails, String method, String uri) {
        // if role ADMIN (full access)
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (isAdmin) {
            return true;
        }

        // get all permission for user/tasker
        Collection<? extends GrantedAuthority> authorities = userDetails.getAuthorities();

        // check permission
        for (GrantedAuthority authority : authorities) {
            String auth = authority.getAuthority();

            if (auth.contains(":")) {
                String[] parts = auth.split(":");
                String permMethod = parts[0];
                String permPath = parts[1];

                // check method. Ex: user want to access GET /list/user
                if (permMethod.equals(method)) {
                    // check method path
                    if (permPath.equals(uri) || pathMatches(permPath, uri)) {
                        return true;
                    }
                }
            }
        }

        // if don't have permission in authorites, will get from db
        return permissionService.checkPermissionUser(
                userDetails.getUsername(), method, uri);
    }

    private boolean pathMatches(String pattern, String uri) {
        // check pattern regex like as "/booking/\d+/assign-tasker"
        try {
            return Pattern.compile(pattern).matcher(uri).matches();
        } catch (Exception e) {
            log.error("Error matching path pattern: {}", e.getMessage());
            return false;
        }
    }

    private void sendUnauthorizedResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(errorResponse(message));
    }

    private void sendForbiddenResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(errorResponse(message));
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(errorResponse(message));
    }

    private String errorResponse(String message) {
        return String.format("{\"success\":false,\"message\":\"%s\"}", message);
    }

    @Getter
    @Setter
    private class ErrorResponse {
        private Date timeStamp;
        private int status;
        private String error;
        private String message;
    }

    // Add custom authentication details class
    public static class CustomWebAuthenticationDetails extends WebAuthenticationDetailsSource {
        private final Integer userId;
        private final String remoteAddress;
        private final String sessionId;

        public CustomWebAuthenticationDetails(HttpServletRequest request, Integer userId) {
            this.userId = userId;
            this.remoteAddress = request.getRemoteAddr();
            this.sessionId = request.getRequestedSessionId();
        }

        public Integer getUserId() {
            return userId;
        }

        public String getRemoteAddress() {
            return remoteAddress;
        }

        public String getSessionId() {
            return sessionId;
        }
    }

}
