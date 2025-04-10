package com.danmin.home_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Tasker;

@Repository
public interface TaskerRepository extends JpaRepository<Tasker, Long> {
    public Tasker findByEmail(String email);
}
