package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.ServiceCategory;

@Repository
public interface ServiceCatetoryRepository extends JpaRepository<ServiceCategory, Long> {
    @Query("SELECT sc FROM ServiceCategory sc ORDER BY sc.name")
    Page<ServiceCategory> findAllServiceCategories(Pageable pageable);

    // For fetching services after getting the categories
    @Query("SELECT sc FROM ServiceCategory sc LEFT JOIN FETCH sc.services s WHERE sc.id IN :ids ORDER BY s.name")
    List<ServiceCategory> findCategoriesWithSortedServicesByIds(@Param("ids") List<Integer> ids);
}
