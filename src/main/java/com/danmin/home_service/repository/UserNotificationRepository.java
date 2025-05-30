package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.UserNotifications;

@Repository
public interface UserNotificationRepository extends JpaRepository<UserNotifications, Long> {
    List<UserNotifications> findByUserIdOrderByCreatedAtDesc(Long userId);

    int countByUserIdAndIsReadFalse(Long userId);

    void deleteByUserId(Long userId);
}
