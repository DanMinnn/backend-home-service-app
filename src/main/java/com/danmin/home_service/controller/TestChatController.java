package com.danmin.home_service.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.service.JwtService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/test-chat")
@RequiredArgsConstructor
public class TestChatController {
    private final JwtService jwtService;

    @GetMapping("/token")
    public Map<String, String> generateTestToken(@RequestParam String role, @RequestParam Integer id) {
        List<GrantedAuthority> authorities = List.of(
                new SimpleGrantedAuthority("ROLE_" + role.toUpperCase()));

        String token = jwtService.generateAccessToken(id, role + id + "@example.com", authorities);

        return Map.of("token", token);
    }
}
