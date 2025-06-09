package com.danmin.home_service.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.TaskerReputation;

@Repository
public interface TaskerReputationRepository extends JpaRepository<TaskerReputation, Long> {

    Optional<TaskerReputation> findByTaskerId(Integer taskerId);

}
