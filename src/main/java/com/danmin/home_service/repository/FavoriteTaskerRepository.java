package com.danmin.home_service.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.dto.response.TaskerReviewResponse;
import com.danmin.home_service.model.FavoriteTasker;

@Repository
public interface FavoriteTaskerRepository extends JpaRepository<FavoriteTasker, Long> {

    List<FavoriteTasker> findByUserId(long userId);

    Optional<FavoriteTasker> findByTaskerId(Integer taskerId);

    @Query("""
            SELECT new com.danmin.home_service.dto.response.TaskerReviewResponse(
            b.tasker.id,
            tr.reputationScore,
            COUNT(r.id))
            FROM Bookings b
            JOIN Review r ON b.id = r.booking.id
            JOIN TaskerReputation tr ON b.tasker.id = tr.taskerId
            WHERE b.tasker.id = :taskerId
            GROUP BY  b.tasker.id, tr.reputationScore
                    """)
    TaskerReviewResponse taskerReviewResponse(@Param("taskerId") Integer taskerId);
}
