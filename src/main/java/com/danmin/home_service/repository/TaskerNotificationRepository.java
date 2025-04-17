package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.common.NotificationStatus;
import com.danmin.home_service.model.TaskerNotification;

@Repository
public interface TaskerNotificationRepository extends JpaRepository<TaskerNotification, Long> {

    List<TaskerNotification> findByTaskerIdAndStatus(Integer taskerId, NotificationStatus status);

}
