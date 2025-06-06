package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.danmin.home_service.model.ChatbotInteraction;

@Repository
public interface ChatbotRepository extends JpaRepository<ChatbotInteraction, Long> {
    @Query("SELECT m FROM ChatbotInteraction m WHERE m.user.id = :userId")
    List<ChatbotInteraction> getChatByUserId(@Param("userId") Integer userId, Pageable pageable);
}
