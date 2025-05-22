package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.ChangePasswordDTO;
import com.danmin.home_service.dto.request.SignInRequest;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.dto.response.TokenResponse;
import com.danmin.home_service.exception.InvalidDataException;
import com.danmin.home_service.service.AuthenticationService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.io.PrintWriter;

import org.springframework.http.HttpStatus;
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
    public ResponseData<TokenResponse> getAccessToken(@Valid @RequestBody SignInRequest request) {
        log.info("Request get access token {}", request.getEmail());
        return new ResponseData<TokenResponse>(HttpStatus.OK.value(), "Login successfully",
                authenticationService.getAccessToken(request));
    }

    @Operation(summary = "Refresh token", description = "Get new access token by refresh token")
    @PostMapping("/refresh-token")
    public ResponseData<TokenResponse> getRefreshToken(@Valid @RequestBody String refreshToken) {
        log.info("Request refresh token");
        return new ResponseData<TokenResponse>(HttpStatus.OK.value(), "Get refresh token",
                authenticationService.getRefreshToken(refreshToken));
    }

    @Operation(summary = "Forgot password")
    @PostMapping("/forgot-password")
    public ResponseData<?> forgotPassword(@Valid @RequestBody String email) {
        log.info("Request forgot password for user with email {}", email);
        String message = authenticationService.forgotPassword(email);
        return new ResponseData<>(HttpStatus.OK.value(), message);
    }

    @Operation(summary = "Confirm reset password", description = "Verify token when click confirm reset password")
    @GetMapping("/tasker/reset-password")
    public ResponseData<?> taskerResetPassword(@RequestParam String data, HttpServletResponse response) {
        log.info("Confirm reset password for tasker");
        try {
            String deepLinkUrl = "homeservicetasker://authorized/reset-password";
            // Append parameters correctly
            String redirectUrl = deepLinkUrl + "?token=" + data;
            String fallbackUrl = "https://tayjava.vn";
            String result = authenticationService.resetPassword(data);
            if (result != null && !result.isEmpty()) {
                redirect(response, redirectUrl, fallbackUrl);
                return new ResponseData(HttpStatus.OK.value(), "Redirect successfully");
            } else {
                return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Redirect failed");
            }
        } catch (InvalidDataException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        } catch (Exception e) {
            log.error("Reset password was failed!, errorMessage={}", e.getMessage());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @Operation(summary = "Change password", description = "Change password for user")
    @PostMapping("/change-password")
    public ResponseData<?> changePassword(@Valid @RequestBody ChangePasswordDTO req) {
        log.info("Change password request received");
        try {

        } catch (InvalidDataException e) {
            log.warn("Change password failed: {}", e.getMessage());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        } catch (Exception e) {
            log.error("Unexpected error during password change: {}", e.getMessage());
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(), "An unexpected error occurred");
        }
        String result = authenticationService.changePassword(req);
        return new ResponseData<>(HttpStatus.OK.value(), result);
    }

    void redirect(HttpServletResponse response, String redirectUrl, String fallbackUrl) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Account Verified Successfully</title>");
        out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
        out.println("<script type=\"text/javascript\">");
        out.println("  window.onload = function() {");
        out.println("    setTimeout(function() {");
        out.println("      window.location.href = '" + redirectUrl + "';");
        out.println("    }, 3000);"); // Delay app open by 3 seconds
        out.println("    setTimeout(function() {");
        out.println("      window.location.href = '" + fallbackUrl + "';");
        out.println("    }, 20000);"); // Fallback after 20 seconds if app didn't open
        out.println("  };");
        out.println("</script>");
        out.println("<style>");
        out.println("  body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }");
        out.println("  .container { max-width: 500px; margin: 0 auto; }");
        out.println("  h1 { color: #4CAF50; }");
        out.println("  p { font-size: 16px; line-height: 1.5; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class=\"container\">");
        out.println("<h1>Email Verified Successfully!</h1>");
        out.println("<p>Redirecting you to the app...</p>");
        out.println("<p>If the app does not open, you will be redirected to the website in a few seconds.</p>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
        out.flush();
    }

}
