package com.danmin.home_service.controller;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.UserRegisterDTO;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.EmailService;
import com.danmin.home_service.service.RedisService;
import com.danmin.home_service.service.RegistrationService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/register/user")
@Tag(name = "User Register Controller")
@Slf4j
@Validated
public class UserRegisterController extends RegistrationController<User, UserRegisterDTO> {

    public UserRegisterController(
            RedisService redisService,
            EmailService emailService,
            RegistrationService registrationService,
            UserRepository userRepository,
            TaskerRepository taskerRepository) {
        super(redisService, emailService, registrationService,
                User.class, "USER", "homeserviceuser://authorized/email-verified", userRepository, taskerRepository);
    }
}
