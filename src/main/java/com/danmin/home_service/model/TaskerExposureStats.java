package com.danmin.home_service.model;

import java.time.LocalDateTime;
import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_exposure_stats")
public class TaskerExposureStats extends AbstractEntity<Long> {

    @Column(name = "tasker_id", nullable = false, unique = true)
    private Long taskerId;

    @Column(name = "notification_count", nullable = false)
    private Long notificationCount;

    @Column(name = "assigned_job_count", nullable = false)
    private Long assignedJobCount;

    @Column(name = "registration_date")
    private Date registrationDate;

    @Column(name = "last_job_date")
    private LocalDateTime lastJobDate;
}
