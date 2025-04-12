package com.danmin.home_service.service;

import java.util.Optional;

import org.springframework.stereotype.Service;

import com.danmin.home_service.model.BaseUser;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserTypeService {
    private final UserRepository userRepository;
    private final TaskerRepository taskerRepository;

    public Optional<BaseUser> findByEmail(String email) {
        Optional<BaseUser> user = userRepository.findByEmail(email).map(u -> (BaseUser) u);
        if (user.isPresent()) {
            return user;
        }
        return taskerRepository.findByEmail(email).map(t -> (BaseUser) t);
    }
}
