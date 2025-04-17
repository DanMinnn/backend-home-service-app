package com.danmin.home_service.model;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.NotificationStatus;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_notification")
public class TaskerNotification extends AbstractEntityCreatedAt<Long> {
    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private Bookings booking;

    @Column(name = "status")
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Enumerated(EnumType.STRING)
    private NotificationStatus status; // SENT, ACCEPTED, REJECTED

    @Column(name = "distance_km")
    private Double distanceKm;

}
