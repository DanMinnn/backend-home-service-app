package com.danmin.home_service.repository;

import com.danmin.home_service.model.FCMToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FCMTokenRepository extends JpaRepository<FCMToken, Long> {
    Optional<FCMToken> findByUserId(Integer userId);

    Optional<FCMToken> findByTaskerId(Integer taskerId);

    Optional<FCMToken> findByDeviceId(String deviceId);
}
