package com.danmin.home_service.service.user;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

import com.danmin.home_service.repository.UserRepository;

@Service
public record UserDetailService(UserRepository userRepository) {
    public UserDetailsService userDetailsService() {
        return userRepository::findByEmail;
    }
}
