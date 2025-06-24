package com.danmin.home_service.repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.model.Bookings;

import jakarta.persistence.LockModeType;

@Repository
public interface BookingRepository extends JpaRepository<Bookings, Long> {

        @Query("SELECT b FROM Bookings b WHERE b.user.id = :userId")
        Page<Bookings> getBookingByUserId(Pageable pageable, @Param("userId") Integer userId);

        // For PostgreSQL - updated to use new timestamp fields
        @Query(value = "SELECT * FROM bookings b WHERE b.user_id = :userId " +
                        "ORDER BY CASE " +
                        "  WHEN b.status = 'pending' THEN 0 " +
                        "  WHEN b.status = 'assigned' THEN 1 " +
                        "  WHEN b.status = 'completed' THEN 2 " +
                        "  WHEN b.status = 'cancelled' THEN 3 " +
                        "  ELSE 4 END, " +
                        "CASE " +
                        "  WHEN b.scheduled_start >= CURRENT_TIMESTAMP THEN b.scheduled_start " +
                        "  ELSE CURRENT_TIMESTAMP + INTERVAL '1000 years' END ASC, " +
                        "b.created_at DESC", nativeQuery = true)
        Page<Bookings> findBookingsByUserIdOrderByScheduledDate(@Param("userId") Integer userId, Pageable pageable);

        @Query("SELECT COUNT(b) FROM Bookings b WHERE b.tasker.id = :taskerId AND b.bookingStatus = 'cancelled' AND b.cancelledByType = 'tasker' AND b.updatedAt >= :sevenDaysAgo")
        int countCancelledBookingsByTaskerInLast7Days(@Param("taskerId") Long taskerId,
                        @Param("sevenDaysAgo") LocalDateTime sevenDaysAgo);

        // Option to fetch bookings and handle sorting in service layer
        @Query("SELECT b FROM Bookings b WHERE b.user.id = :userId")
        List<Bookings> findAllBookingsByUserId(@Param("userId") Integer userId);

        /**
         * Finds all bookings for a user with a specific status
         */
        @Query("SELECT b FROM Bookings b WHERE b.user.id = :userId AND b.bookingStatus = :status")
        List<Bookings> findBookingsByUserIdAndStatus(@Param("userId") Integer userId,
                        @Param("status") BookingStatus status);

        /* Get booking for tasker with service corresponds */
        @Query("""
                        SELECT b FROM Bookings b WHERE b.bookingStatus = 'pending' AND b.service.id IN :serviceIds
                        """)
        List<Bookings> getTaskForTasker(
                        @Param("serviceIds") List<Long> serviceIds);

        /* Get booking was assigned by Tasker */
        @Query("SELECT b FROM Bookings b WHERE b.tasker.id = :taskerId AND b.bookingStatus = 'assigned'")
        List<Bookings> getTaskAssignByTasker(@Param("taskerId") Long taskerId);

        /*
         * Get booking was assigned by Tasker follow date time - updated to use
         * scheduled_start
         */
        @Query("SELECT b FROM Bookings b WHERE b.tasker.id = :taskerId " +
                        "AND b.bookingStatus = 'assigned' " +
                        "AND DATE(b.scheduledStart) = :selectedDate " +
                        "ORDER BY b.scheduledStart ASC")
        List<Bookings> getTaskAssignByTaskerFollowDate(
                        @Param("taskerId") Long taskerId,
                        @Param("selectedDate") LocalDate selectedDate);

        @Lock(LockModeType.PESSIMISTIC_WRITE)
        @Query("SELECT b FROM Bookings b WHERE b.id = :id")
        Optional<Bookings> findByIdWithPessimisticLock(@Param("id") Long id);

        // schedule auto update booking status
        @Query("SELECT b FROM Bookings b " +
                        "WHERE b.bookingStatus = 'assigned' " +
                        "AND b.scheduledStart <= :now AND b.scheduledEnd > :now")
        List<Bookings> findAssignedBookingsInProgressWindow(@Param("now") LocalDateTime now);

        @Query("SELECT b FROM Bookings b " +
                        "WHERE b.bookingStatus = 'in_progress' " +
                        "AND b.scheduledEnd < :now")
        List<Bookings> findInProgressBookingsCompletedWindow(@Param("now") LocalDateTime now);

        ///
        @Query("SELECT b FROM Bookings b " +
                        "WHERE b.tasker.id = :taskerId " +
                        "AND b.bookingStatus = 'completed' OR b.bookingStatus = 'cancelled'")
        List<Bookings> findHistoryTask(@Param("taskerId") Integer taskerId);

        /*
         * Get all bookings filtered by status and selectedDate
         */
        @Query("SELECT b FROM Bookings b WHERE b.bookingStatus = :status " +
                        "AND DATE(b.scheduledStart) = :selectedDate " +
                        "ORDER BY b.scheduledStart ASC")
        List<Bookings> getAllBookingsFilterByStatusAndSpecifiedDate(
                        @Param("status") BookingStatus status,
                        @Param("selectedDate") LocalDate selectedDate);

        /*
         * Get all bookings filtered by status
         */
        @Query("SELECT b FROM Bookings b WHERE b.bookingStatus = :status ")
        List<Bookings> getAllBookingsFilterByStatus(
                        @Param("status") BookingStatus status);

        /*
         * Get all bookings filtered by selectedDate
         */
        @Query("SELECT b FROM Bookings b WHERE DATE(b.scheduledStart) = :selectedDate " +
                        "ORDER BY b.scheduledStart ASC")
        List<Bookings> getAllBookingsBySpecifiedDate(
                        @Param("selectedDate") LocalDate selectedDate);

        /*
         * Get all bookings with no filter
         */
        @Query("SELECT b FROM Bookings b ORDER BY b.scheduledStart ASC")
        List<Bookings> getAllBookingsWithNoFilter();

        /*
         * Search bookings by customer name
         */
        @Query("SELECT b FROM Bookings b WHERE LOWER(b.user.firstLastName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) ")
        List<Bookings> findBookingsByCustomerName(@Param("searchTerm") String searchTerm);

        /*
         * Search bookings by tasker name
         */
        @Query("SELECT b FROM Bookings b WHERE b.tasker IS NOT NULL AND LOWER(b.tasker.firstLastName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) ")
        List<Bookings> findBookingsByTaskerName(@Param("searchTerm") String searchTerm);

        /*
         * Queries below for statistics
         */
        @Query("SELECT COUNT(b) FROM Bookings b WHERE b.bookingStatus = 'completed' AND b.updatedAt BETWEEN :fromDate AND :toDate")
        Long countCompletedTasksByDateRange(@Param("fromDate") LocalDateTime fromDate,
                        @Param("toDate") LocalDateTime toDate);

        @Query("SELECT COUNT(b) FROM Bookings b WHERE b.bookingStatus = 'pending'")
        Long countPendingBookings();

        @Query("SELECT b FROM Bookings b ORDER BY b.createdAt DESC")
        List<Bookings> findRecentBookings(Pageable pageable);

        @Query("SELECT s.id as serviceId, s.name as serviceName, COUNT(b) as bookingCount " +
                        "FROM Bookings b JOIN b.service s " +
                        "WHERE b.createdAt BETWEEN :fromDate AND :toDate " +
                        "GROUP BY s.id, s.name ORDER BY COUNT(b) DESC")
        List<Object[]> findMostBookedServices(
                        @Param("fromDate") LocalDateTime fromDate,
                        @Param("toDate") LocalDateTime toDate,
                        Pageable pageable);

        @Query("SELECT b.bookingStatus as status, COUNT(b) as count " +
                        "FROM Bookings b " +
                        "WHERE b.createdAt BETWEEN :fromDate AND :toDate " +
                        "GROUP BY b.bookingStatus")
        List<Object[]> findBookingStatusDistribution(
                        @Param("fromDate") LocalDateTime fromDate,
                        @Param("toDate") LocalDateTime toDate);
}
