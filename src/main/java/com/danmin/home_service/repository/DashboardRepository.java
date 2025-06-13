package com.danmin.home_service.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.dto.response.dashboard.BookingStatusCountResponse;
import com.danmin.home_service.dto.response.dashboard.BookingTrendResponse;
import com.danmin.home_service.dto.response.dashboard.ServiceRevenueResponse;
import com.danmin.home_service.dto.response.dashboard.TopServiceResponse;
import com.danmin.home_service.dto.response.dashboard.TopTaskerResponse;
import com.danmin.home_service.model.Bookings;

@Repository
public interface DashboardRepository extends JpaRepository<Bookings, Long> {

  // 1. Completed Tasks Count
  @Query("SELECT COUNT(b) FROM Bookings b WHERE b.bookingStatus = 'completed' AND b.completedAt BETWEEN :fromDate AND :toDate")
  Long countCompletedTasksByDateRange(@Param("fromDate") LocalDateTime fromDate,
      @Param("toDate") LocalDateTime toDate);

  // 2. Pending Bookings Count
  @Query("SELECT COUNT(b) FROM Bookings b WHERE b.bookingStatus = 'pending'")
  Long countPendingBookings();

  // 3. User Registration Counts
  @Query("SELECT COUNT(u) FROM User u WHERE u.createdAt BETWEEN :fromDate AND :toDate")
  Long countUserRegistrationsByDateRange(@Param("fromDate") LocalDateTime fromDate,
      @Param("toDate") LocalDateTime toDate);

  @Query("SELECT COUNT(t) FROM Tasker t WHERE t.createdAt BETWEEN :fromDate AND :toDate")
  Long countTaskerRegistrationsByDateRange(@Param("fromDate") LocalDateTime fromDate,
      @Param("toDate") LocalDateTime toDate);

  @Query(value = """
      SELECT DATE_TRUNC('day', created_at) as timePoint , COUNT(*) as count
      FROM bookings
      WHERE created_at BETWEEN :fromDate AND :toDate
      GROUP BY DATE_TRUNC('day', created_at)
      ORDER BY DATE_TRUNC('day', created_at)
      """, nativeQuery = true)
  List<BookingTrendResponse> getBookingTrendsByInterval(
      @Param("fromDate") LocalDateTime fromDate,
      @Param("toDate") LocalDateTime toDate);

  // 5. Most Booked Services
  @Query("SELECT new com.danmin.home_service.dto.response.dashboard.TopServiceResponse(" +
      "s.id, s.name, s.category.name, COUNT(b)) " +
      "FROM Bookings b " +
      "JOIN b.service s " +
      "WHERE b.createdAt BETWEEN :fromDate AND :toDate " +
      "GROUP BY s.id, s.name, s.category.name " +
      "ORDER BY COUNT(b) DESC")
  List<TopServiceResponse> getMostBookedServices(
      @Param("fromDate") LocalDateTime fromDate,
      @Param("toDate") LocalDateTime toDate,
      @Param("limit") int limit);

  // 6. Booking Status Distribution
  @Query("SELECT new com.danmin.home_service.dto.response.dashboard.BookingStatusCountResponse(" +
      "b.bookingStatus, COUNT(b)) " +
      "FROM Bookings b " +
      "WHERE b.createdAt BETWEEN :fromDate AND :toDate " +
      "GROUP BY b.bookingStatus")
  List<BookingStatusCountResponse> getBookingStatusDistribution(
      @Param("fromDate") LocalDateTime fromDate,
      @Param("toDate") LocalDateTime toDate);

  // 7. Recent Bookings
  @Query("SELECT b FROM Bookings b ORDER BY b.createdAt DESC")
  List<Bookings> findRecentBookings(Pageable pageable);

  // 8. Top Taskers by Rating and Completed Tasks
  @Query("""
      SELECT new com.danmin.home_service.dto.response.dashboard.TopTaskerResponse(
        t.id,
        t.firstLastName,
        t.profileImage,
        tr.reputationScore,
        COUNT(b)
      )
      FROM Tasker t
      JOIN TaskerReputation tr ON t.id = tr.taskerId
      LEFT JOIN Bookings b ON b.tasker = t AND b.bookingStatus = 'completed'
      WHERE tr.reputationScore IS NOT NULL
      GROUP BY t.id, t.firstLastName, t.profileImage, tr.reputationScore
      ORDER BY tr.reputationScore DESC, COUNT(b) DESC
      """)
  List<TopTaskerResponse> findTopTaskers(Pageable pageable);

  // Count total users and taskers
  @Query("SELECT COUNT(u) FROM User u")
  Long countTotalUsers();

  @Query("SELECT COUNT(t) FROM Tasker t")
  Long countTotalTaskers();

  // Calculate total revenue per service
  @Query("SELECT new com.danmin.home_service.dto.response.dashboard.ServiceRevenueResponse(" +
      "s.id, s.name, s.category.name, SUM(b.totalPrice), COUNT(b)) " +
      "FROM Bookings b " +
      "JOIN b.service s " +
      "WHERE b.bookingStatus = 'completed' AND " +
      "b.paymentStatus = 'paid' AND " +
      "b.completedAt BETWEEN :fromDate AND :toDate " +
      "GROUP BY s.id, s.name, s.category.name " +
      "ORDER BY SUM(b.totalPrice) DESC")
  List<ServiceRevenueResponse> calculateServiceRevenue(
      @Param("fromDate") LocalDateTime fromDate,
      @Param("toDate") LocalDateTime toDate);
}
