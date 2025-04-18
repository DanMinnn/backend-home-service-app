package com.danmin.home_service.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.ChatRoom;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoom, Integer> {

    Optional<ChatRoom> findByUserIdAndTaskerIdAndBookingId(Integer userId, Integer taskerId, Long bookingId);

    List<ChatRoom> findUserById(Integer userId);

    List<ChatRoom> findTaskerById(Integer taskerId);

    @Query("SELECT cr FROM ChatRoom cr WHERE cr.user =:userId OR cr.tasker =:taskerId ORDER BY cr.lastMessageAt DESC")
    List<ChatRoom> findChatRoomByUserIdOrTaskerId(@Param("userId") Integer userId, @Param("taskerId") Integer taskerId);
}
