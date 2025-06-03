package com.danmin.home_service.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.model.ChatMessage;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Integer> {

        @Query("SELECT m FROM ChatMessage m WHERE m.chatRoom.id = :roomId ORDER BY m.sentAt ASC")
        List<ChatMessage> findChatRoomByIdOrderBySentAtAsc(@Param("roomId") Integer roomId);

        @EntityGraph(attributePaths = {
                        "chatRoom", "chatRoom.tasker", "chatRoom.user"
        })
        @Query("SELECT m FROM ChatMessage m WHERE m.chatRoom.id = :roomId ORDER BY m.sentAt DESC")
        List<ChatMessage> findChatRoomByIdOrderBySentAtDesc(@Param("roomId") Integer roomId, Pageable pageable);

        @Query("SELECT m FROM ChatMessage m WHERE m.chatRoom.id = :roomId ORDER BY m.sentAt DESC LIMIT 1")
        Optional<ChatMessage> findTopChatRoomByIdOrderBySentAtDesc(@Param("roomId") Integer roomId);

        @Query("SELECT m FROM ChatMessage m WHERE m.chatRoom.id = :roomId AND m.readAt IS NULL AND m.senderId != :userId AND m.senderType = :senderType")
        List<ChatMessage> findUnreadMessagesForUser(@Param("roomId") Integer roomId, @Param("userId") Integer userId,
                        @Param("senderType") SenderType senderType);

        @Query("SELECT COUNT(m) FROM ChatMessage m WHERE m.chatRoom.id = :roomId AND m.readAt IS NULL AND m.senderId != :userId AND m.senderType = :senderType")
        Integer countUnreadMessagesForUser(@Param("roomId") Integer roomId, @Param("userId") Integer userId,
                        @Param("senderType") SenderType senderType);
}
