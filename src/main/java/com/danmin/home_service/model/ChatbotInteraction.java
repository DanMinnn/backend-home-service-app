package com.danmin.home_service.model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chatbot_interactions")
public class ChatbotInteraction extends AbstractEntityCreatedAt<Long> {

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "query", nullable = false)
    private String message;

    @Column(name = "response", nullable = false)
    private String response;
}
