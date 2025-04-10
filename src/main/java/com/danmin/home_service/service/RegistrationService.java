package com.danmin.home_service.service;

import com.danmin.home_service.dto.request.RegisterRequestDTO;

public interface RegistrationService {

    long saveUserOrTasker(RegisterRequestDTO request);
}
