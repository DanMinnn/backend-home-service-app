package com.danmin.home_service.repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Tasker;

@Repository
public interface TaskerRepository extends JpaRepository<Tasker, Long> {

  Optional<Tasker> findByEmail(String email);

  @Query(value = """
          SELECT t.id,
                 ST_DistanceSphere(t.earth_location, ST_MakePoint(:lng, :lat)) / 1000 as distance_km
          FROM tasker t
          JOIN tasker_services ts ON t.id = ts.tasker_id
          WHERE t.availability_status = 'available'
            AND ts.service_id = :serviceId
            AND ST_DistanceSphere(t.earth_location, ST_MakePoint(:lng, :lat)) <= :radiusInMeters
          ORDER BY distance_km ASC
          LIMIT :limit
      """, nativeQuery = true)
  List<Object[]> findAvailableTaskersNearby(
      @Param("lat") BigDecimal latitude,
      @Param("lng") BigDecimal longitude,
      @Param("radiusInMeters") double radiusInMeters,
      @Param("serviceId") Long serviceId,
      @Param("limit") int limit);
}
