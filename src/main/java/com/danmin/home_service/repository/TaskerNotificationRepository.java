package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.danmin.home_service.model.TaskerNotification;

@Repository
public interface TaskerNotificationRepository extends JpaRepository<TaskerNotification, Long> {

    List<TaskerNotification> findByTaskerIdOrderByCreatedAtDesc(Long taskerId);

    List<TaskerNotification> findByBookingId(Long bookingId);

    int countByTaskerIdAndIsReadFalse(Long taskerId);

    void deleteByTaskerId(Long taskerId);
}
