package com.danmin.home_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Services;

@Repository
public interface ServiceRepository extends JpaRepository<Services, Long> {

}
