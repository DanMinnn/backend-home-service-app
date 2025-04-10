package com.danmin.home_service.service.user;

import com.danmin.home_service.dto.request.UserRegisterDTO;

public interface UserRegisterService {

    long saveUser(UserRegisterDTO reqUser);

}
