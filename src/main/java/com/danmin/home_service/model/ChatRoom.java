package com.danmin.home_service.model;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chat_rooms")
public class ChatRoom extends AbstractEntityCreatedAt<Integer> {

    @OneToOne
    @JoinColumn(name = "booking_id")
    private Bookings booking;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @Column(name = "last_message_at")
    private LocalDateTime lastMessageAt;
}
