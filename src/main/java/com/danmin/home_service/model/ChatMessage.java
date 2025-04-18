package com.danmin.home_service.model;

import java.sql.Date;
import java.time.LocalDateTime;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.SenderType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chat_messages")
public class ChatMessage extends AbstractEntityNoDate<Integer> {

    @ManyToOne
    @JoinColumn(name = "room_id")
    private ChatRoom chatRoom;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    private SenderType senderType;

    @Column(name = "sender_id", nullable = false)
    private Integer senderId;

    @Column(name = "message_text", nullable = false)
    private String messageText;

    @Column(name = "sent_at")
    private LocalDateTime sentAt;

    @Column(name = "read_at")
    private Date readAt;
}
