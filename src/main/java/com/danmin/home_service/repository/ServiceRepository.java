package com.danmin.home_service.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Services;

@Repository
public interface ServiceRepository extends JpaRepository<Services, Long> {

    @Query("SELECT s FROM Services s LEFT JOIN FETCH s.servicePackages")
    Page<Services> findAllWithServicesPackage(Pageable pageable);
}
