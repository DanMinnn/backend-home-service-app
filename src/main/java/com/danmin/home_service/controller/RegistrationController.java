package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.danmin.home_service.dto.request.RegisterDTO;
import com.danmin.home_service.model.AbstractUser;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.EmailService;
import com.danmin.home_service.service.RedisService;
import com.danmin.home_service.service.RegistrationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
public abstract class RegistrationController<T extends AbstractUser<?>, D extends RegisterDTO> {
    protected final RedisService redisService;
    protected final EmailService emailService;
    protected final RegistrationService registrationService;
    protected final Class<T> userType;
    protected final String userTypeString;
    protected final String redirectUrl;
    protected final UserRepository userRepository;
    protected final TaskerRepository taskerRepository;

    @PostMapping("/")
    public String register(@Valid @RequestBody D req) {
        log.info("Request add {} {}", userTypeString, req.getFirstLastName());

        try {
            var emailUser = userRepository.findByEmail(req.getEmail());
            var emailTasker = taskerRepository.findByEmail(req.getEmail());

            if (emailUser.isPresent() || emailTasker.isPresent()) {
                // Check if email already exists in either User or Tasker repository
                log.error("Email {} already exists", req.getEmail());
                return "Email already exists";
            }
            // save registration into Redis
            redisService.save("REGISTER::" + userTypeString, req, 24);
            emailService.sendEmailVerification(req.getEmail(), userTypeString);
            return "Verification code sent to your email.";
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return "Failed to send verification code.";
        }
    }

}
