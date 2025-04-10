package com.danmin.home_service.controller;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.RegisterRequestDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.service.RedisService;
import com.danmin.home_service.service.RegistrationService;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/register")
@Tag(name = "Register Controller")
@RequiredArgsConstructor
@Slf4j
@Validated
public class RegisterController {

    private final RegistrationService registrationService;
    private final RedisService redisService;

    @PostMapping("/")
    public ResponseData<Long> addUser(@Valid @RequestBody RegisterRequestDTO req) {

        log.info("Request add user " + req.getFirstName());
        try {
            long userId = registrationService.saveUserOrTasker(req);
            return new ResponseData<>(HttpStatus.CREATED.value(), "successfull", userId);
        } catch (ResourceNotFoundException e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            System.out.println("errorMessage={}" + e.getMessage() + e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @GetMapping("/confirm-email")
    public void confirmEmail(@RequestParam String secretCode, HttpServletResponse response) throws IOException {
        log.info("Confirm email: {}", secretCode);

        try {
            // TODO check secretCode from Redis
            String key = redisService.getSecretCode("secretCode");

            if (key == null) {
                log.info("Verification expired or registration not found.");
            }

            redisService.delete("secretCode");

        } catch (Exception e) {
            log.error("Confirm email was failed!, errorMessage={}", e.getMessage());
        } finally {
            response.sendRedirect("https://tayjava.vn/wp-admin");
        }
    }

}
