package com.danmin.home_service.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.ChatRoom;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoom, Integer> {

    Optional<ChatRoom> findByUserIdAndTaskerIdAndBookingId(Integer userId, Integer taskerId, Long bookingId);

    List<ChatRoom> findRoomByUserId(Integer userId);

    List<ChatRoom> findRoomByTaskerId(Integer taskerId);

    @Query("SELECT cr FROM ChatRoom cr WHERE cr.user =:userId OR cr.tasker =:taskerId ORDER BY cr.lastMessageAt DESC")
    List<ChatRoom> findChatRoomByUserIdOrTaskerId(@Param("userId") Integer userId, @Param("taskerId") Integer taskerId);

    @Query("SELECT cr FROM ChatRoom cr LEFT JOIN FETCH cr.user LEFT JOIN FETCH cr.tasker WHERE cr.id = :id")
    Optional<ChatRoom> findByIdWithUserAndTasker(@Param("id") Integer id);

    @Query("SELECT cr.id as id, cr.user.id as userId, cr.tasker.id as taskerId FROM ChatRoom cr WHERE cr.id = :id")
    Optional<ChatRoomBasicInfo> findBasicInfoById(@Param("id") Integer id);

    @Modifying
    @Query("UPDATE ChatRoom cr SET cr.lastMessageAt = :lastMessageAt WHERE cr.id = :roomId")
    void updateLastMessageAt(@Param("roomId") Integer roomId, @Param("lastMessageAt") LocalDateTime lastMessageAt);

    // Projection interface for basic chat room info
    interface ChatRoomBasicInfo {
        Integer getId();

        Integer getUserId();

        Integer getTaskerId();
    }
}
