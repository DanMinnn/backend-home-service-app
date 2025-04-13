package com.danmin.home_service.service;

import com.danmin.home_service.dto.request.ChangePasswordDTO;
import com.danmin.home_service.dto.request.SignInRequest;
import com.danmin.home_service.dto.response.TokenResponse;

public interface AuthenticationService {

    TokenResponse getAccessToken(SignInRequest request);

    TokenResponse getRefreshToken(String request);

    String forgotPassword(String email);

    String resetPassword(String key);

    String changePassword(ChangePasswordDTO request);
}
