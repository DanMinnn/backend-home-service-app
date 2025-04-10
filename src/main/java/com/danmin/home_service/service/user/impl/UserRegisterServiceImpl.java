package com.danmin.home_service.service.user.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.request.UserRegisterDTO;
import com.danmin.home_service.exception.InvalidDataException;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.user.UserRegisterService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserRegisterServiceImpl implements UserRegisterService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional(rollbackOn = Exception.class)
    public long saveUser(UserRegisterDTO reqUser) {

        User userByEmail = userRepository.findByEmail(reqUser.getEmail());

        if (userByEmail != null) {
            throw new InvalidDataException("Email already exists");
        }

        User user = User.builder().firstLastName(reqUser.getFirstLastName())
                .email(reqUser.getEmail())
                .phoneNumber(reqUser.getPhoneNumber())
                .passwordHash(passwordEncoder.encode(reqUser.getPassword()))
                .userType(reqUser.getType())
                .isVerified(reqUser.isVerify()).build();

        userRepository.save(user);

        return user.getId();
    }

}
