package com.danmin.home_service.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.TaskerExposureStats;

@Repository
public interface TaskerExposureStatsRepository extends JpaRepository<TaskerExposureStats, Long> {

    Optional<TaskerExposureStats> findByTaskerId(Long taskerId);
}
