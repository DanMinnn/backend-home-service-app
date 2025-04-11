package com.danmin.home_service.service;

import com.danmin.home_service.dto.request.RegisterDTO;
import com.danmin.home_service.model.AbstractUser;

public interface RegistrationService {
    public <T extends AbstractUser<?>> long registerUser(RegisterDTO dto, Class<T> userType);

    boolean verifyUser(String secretCode, String userType);

}
