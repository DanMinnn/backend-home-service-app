package com.danmin.home_service.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {

    @Value("${firebase.config.path:}")
    private String firebaseConfigPath;

    @Value("${firebase.config.json:}")
    private String firebaseConfigJson;

    @PostConstruct
    public void initialize() {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
                GoogleCredentials credentials;

                if (!firebaseConfigJson.isEmpty()) {
                    credentials = GoogleCredentials.fromStream(
                            new ByteArrayInputStream(firebaseConfigJson.getBytes()));
                } else if (!firebaseConfigPath.isEmpty()) {
                    try {
                        credentials = GoogleCredentials.fromStream(
                                new ClassPathResource(firebaseConfigPath).getInputStream());
                    } catch (Exception e) {
                        credentials = GoogleCredentials.fromStream(
                                new FileInputStream(firebaseConfigPath));
                    }
                } else {
                    throw new RuntimeException(
                            "Firebase configuration not found. Please set firebase.config.json or firebase.config.path");
                }

                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(credentials)
                        .build();

                FirebaseApp.initializeApp(options);
                System.out.println("Firebase initialized successfully");
            }
        } catch (IOException e) {
            System.err.println("Error initializing Firebase: " + e.getMessage());
            throw new RuntimeException("Error initializing Firebase", e);
        }
    }
}
