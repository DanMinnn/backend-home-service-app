package com.danmin.home_service.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.ServiceCategory;

@Repository
public interface ServiceCatetoryRepository extends JpaRepository<ServiceCategory, Long> {
    @Query("SELECT sc FROM ServiceCategory sc LEFT JOIN FETCH sc.services")
    Page<ServiceCategory> findAllWithServices(Pageable pageable);
}
