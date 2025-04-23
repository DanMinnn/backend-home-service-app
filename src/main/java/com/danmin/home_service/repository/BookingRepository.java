package com.danmin.home_service.repository;

import java.time.LocalDateTime;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Bookings;

@Repository
public interface BookingRepository extends JpaRepository<Bookings, Long> {

    @Query("SELECT COUNT(b) FROM Bookings b " +
            "WHERE b.tasker.id = :taskerId " +
            "AND b.bookingStatus = 'cancelled' " +
            "AND b.cancelledByType = 'tasker' " +
            "AND b.updatedAt >= :fromDate")
    int countCancelledBookingsByTaskerInLast7Days(@Param("taskerId") Long taskerId,
            @Param("fromDate") LocalDateTime fromDate);
}
