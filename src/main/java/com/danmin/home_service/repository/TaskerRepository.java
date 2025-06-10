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

  Tasker findTaskerByEmail(String email);

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

  // notify to tasker with service corresponds
  @Query(value = """
          SELECT t.id
          FROM tasker t
          JOIN tasker_services ts ON t.id = ts.tasker_id
          WHERE t.availability_status = 'available'
            AND ts.service_id = :serviceId
          LIMIT :limit
      """, nativeQuery = true)
  List<Tasker> findAvailableTaskers(
      @Param("serviceId") Long serviceId,
      @Param("limit") int limit);

  @Query(value = """
          SELECT t.*
          FROM tasker t
          JOIN tasker_services ts ON t.id = ts.tasker_id
          LEFT JOIN tasker_reputation tr ON t.id = tr.tasker_id
          WHERE t.availability_status = 'available'
            AND ts.service_id = :serviceId
          ORDER BY COALESCE(tr.reputation_score, 3.0) DESC
          LIMIT :limit
      """, nativeQuery = true)
  List<Tasker> findAvailableTaskersByReputationAndService(
      @Param("serviceId") Long serviceId,
      @Param("limit") int limit);

  @Query(value = """
          SELECT t.*
          FROM tasker t
          JOIN tasker_services ts ON t.id = ts.tasker_id
          WHERE t.availability_status = 'available'
            AND ts.service_id = :serviceId
          ORDER BY RANDOM()
          LIMIT :limit
      """, nativeQuery = true)
  List<Tasker> findRandomAvailableTaskers(
      @Param("serviceId") Long serviceId,
      @Param("limit") int limit);

  /**
   * Purpose is use to NotificationService class
   */
  @Query(value = "SELECT t FROM Tasker t " +
      "JOIN t.taskerServices ts " +
      "WHERE t.availabilityStatus = 'available' " +
      "AND ts.service.id = :serviceId")
  List<Tasker> findAvailableTaskersByService(@Param("serviceId") Long serviceId);

  @Query(value = "SELECT t FROM Tasker t JOIN Bookings b ON b.tasker.id = t.id WHERE t.availabilityStatus = 'available' AND b.bookingStatus = 'assigned' AND b.id = :bookingId")
  Tasker findTaskerByBookingId(@Param("bookingId") Long bookingId);
}
