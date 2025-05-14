package com.danmin.home_service.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Bookings;

@Repository
public interface BookingRepository extends JpaRepository<Bookings, Long> {

        @Query("SELECT b FROM Bookings b WHERE b.user.id = :userId")
        Page<Bookings> getBookingByUserId(Pageable pageable, @Param("userId") Integer userId);

        // For PostgreSQL
        @Query(value = "SELECT * FROM bookings b WHERE b.user_id = :userId " +
                        "ORDER BY CASE " +
                        "  WHEN b.status = 'pending' THEN 0 " +
                        "  WHEN b.status = 'assigned' THEN 1 " +
                        "  WHEN b.status = 'completed' THEN 2 " +
                        "  WHEN b.status = 'cancelled' THEN 3 " +
                        "  ELSE 4 END, " +
                        "CASE " +
                        "  WHEN TO_TIMESTAMP(b.scheduled_date, 'YYYY-MM-DD HH24:MI') >= CURRENT_TIMESTAMP THEN TO_TIMESTAMP(b.scheduled_date, 'YYYY-MM-DD HH24:MI') "
                        +
                        "  ELSE CURRENT_TIMESTAMP + INTERVAL '1000 years' END ASC, " +
                        "b.created_at DESC", nativeQuery = true)
        Page<Bookings> findBookingsByUserIdOrderByScheduledDate(@Param("userId") Integer userId, Pageable pageable);

        @Query("SELECT COUNT(b) FROM Bookings b WHERE b.tasker.id = :taskerId AND b.bookingStatus = 'cancelled' AND b.cancelledByType = 'tasker' AND b.updatedAt >= :sevenDaysAgo")
        int countCancelledBookingsByTaskerInLast7Days(@Param("taskerId") Long taskerId,
                        @Param("sevenDaysAgo") LocalDateTime sevenDaysAgo);

        /**
         * Finds all bookings for a user without any sorting.
         * The sorting will be handled in the service layer.
         */
        @Query("SELECT b FROM Bookings b WHERE b.user.id = :userId")
        List<Bookings> findAllBookingsByUserId(@Param("userId") Integer userId);
}
