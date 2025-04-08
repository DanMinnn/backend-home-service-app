package com.danmin.home_service.model;

import java.util.Date;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.ChangedByType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "booking_status_history")
public class BookingStatusHistory extends AbstractEntityNoDate<Integer> {

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private Bookings bookings;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status")
    private BookingStatus bookingStatus;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "changed_by")
    private ChangedByType changedByType;

    // client, tasker, admin
    @Column(name = "changed_by_id")
    private Integer changedById;

    @Column(name = "changed_at")
    private Date changedAt;

    @Column(columnDefinition = "TEXT")
    private String notes;
}
