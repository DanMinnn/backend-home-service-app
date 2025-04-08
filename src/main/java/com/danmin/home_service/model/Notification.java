package com.danmin.home_service.model;

import java.util.Date;

import com.danmin.home_service.common.RecipientType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "notifications")
public class Notification extends AbstractEntity<Long> {

    @Enumerated(EnumType.STRING)
    @Column(name = "recipient_type", nullable = false)
    private RecipientType recipientType;

    @Column(name = "recipient_id", nullable = false)
    private Integer recipientId;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "message", nullable = false)
    private String message;

    @Column(name = "notification_type", nullable = false)
    private String notificationType;

    @Column(name = "related_entity")
    private String relatedEntity;

    @Column(name = "related_entity_id")
    private Integer relatedEntityId;

    @Column(name = "is_read", columnDefinition = "BOOLEAN DEFAULT false")
    private Boolean isRead;

    @Column(name = "read_at")
    private Date readAt;
}
