package com.danmin.home_service.service.impl;

import java.io.IOException;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.danmin.home_service.common.AvailabilityStatus;
import com.danmin.home_service.common.UserType;
import com.danmin.home_service.dto.request.RegisterRequestDTO;
import com.danmin.home_service.exception.InvalidDataException;
import com.danmin.home_service.model.Account;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.AccountRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.EmailService;
import com.danmin.home_service.service.RegistrationService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RegistrationServiceImpl implements RegistrationService {

    private final UserRepository userRepository;
    private final TaskerRepository taskerRepository;
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    @Override
    @Transactional(rollbackOn = Exception.class)
    public long saveUserOrTasker(RegisterRequestDTO request) {

        // Account userByEmail = accountRepository.findByEmail(request.getEmail());

        // if (userByEmail != null) {
        // throw new InvalidDataException("Email already exists");
        // }

        User user = User.builder().userType(request.getType()).build();

        userRepository.save(user);

        Account account = Account.builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail())
                .phoneNumber(request.getPhoneNumber())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .build();

        if (request.getType() == UserType.tasker) {
            Tasker tasker = Tasker.builder().availabilityStatus(AvailabilityStatus.available).build();
            taskerRepository.save(tasker);
            account.setTasker(tasker);
        } else {
            account.setUser(user);
        }

        accountRepository.save(account);

        // send email
        try {
            emailService.sendEmailVerification(request.getEmail());
        } catch (IOException e) {
            throw new RuntimeException();
        }

        return account.getId();
    }

}
