package com.danmin.home_service.controller.common;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.RegistrationService;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/register")
@Slf4j
@RequiredArgsConstructor
public class CommonRegistrationController {
    private final RegistrationService registrationService;

    @GetMapping("/confirm-email")
    public ResponseData<Long> confirmEmail(@RequestParam String secretCode, @RequestParam String userType,
            HttpServletResponse response)
            throws IOException {
        log.info("Confirm email for {}: {}", userType, secretCode);

        try {
            boolean verified = registrationService.verifyUser(secretCode, userType);

            if (!verified) {
                return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Verification failed or expired");
            }

            // Xác định URL redirect dựa vào loại người dùng
            String redirectUrl;
            if ("USER".equals(userType)) {
                redirectUrl = "https://tayjava.vn/wp-admin";
            } else if ("TASKER".equals(userType)) {
                redirectUrl = "https://tayjava.vn/tasker-dashboard";
            } else {
                redirectUrl = "https://tayjava.vn";
            }

            response.sendRedirect(redirectUrl);

            return new ResponseData<>(HttpStatus.OK.value(), "Registration completed successfully", null);
        } catch (Exception e) {
            log.error("Confirm email was failed!, errorMessage={}", e.getMessage());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Registration failed");
        } finally {
            response.sendRedirect("https://study4.com/tests/toeic/?term=2023");
        }
    }
}
