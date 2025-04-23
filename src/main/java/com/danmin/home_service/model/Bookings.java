package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.Date;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.CancelledByType;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "bookings")
public class Bookings extends AbstractEntity<Long> {

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "service_id")
    private Services service;

    @Column(name = "address_name")
    private String address;

    @Column(name = "scheduled_date")
    private String scheduledDate;

    @Column(name = "duration")
    private String duration;

    @Column(name = "work_load")
    private String workLoad;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    @Column(name = "completed_at")
    @CreationTimestamp
    private Date completedAt;

    @Column(name = "latitude")
    private BigDecimal latitude;

    @Column(name = "longitude")
    private BigDecimal longitude;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status")
    private BookingStatus bookingStatus;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "cancellation_reason", columnDefinition = "TEXT")
    private String cancellationReason;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "cancelled_by")
    private CancelledByType cancelledByType;

    @Column(name = "is_recurring")
    private Boolean isRecurring;

    @Column(name = "recurring_pattern")
    private String recurringPattern;

    @Column(name = "payment_status")
    private String paymentStatus;
}
