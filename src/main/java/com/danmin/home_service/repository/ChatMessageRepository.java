package com.danmin.home_service.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.ChatMessage;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Integer> {

    List<ChatMessage> findChatRoomByIdOrderBySentAtAsc(Integer roomId);

    List<ChatMessage> findChatRoomByIdOrderBySentAtDesc(Integer roomId, Pageable pageable);

    Optional<ChatMessage> findTopChatRoomByIdOrderBySentAtDesc(Integer roomId);
}
