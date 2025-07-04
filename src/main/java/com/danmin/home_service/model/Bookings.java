package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.Type;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.CancelledByType;
import com.fasterxml.jackson.annotation.JsonIgnore;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
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

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "package_id")
    private ServicePackages packages;

    @Column(name = "address_name")
    private String address;

    @Type(JsonBinaryType.class)
    @Column(name = "task_details", columnDefinition = "jsonb")
    private Map<String, Object> taskDetails;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    @Column(name = "completed_at")
    @CreationTimestamp
    private LocalDateTime completedAt;

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

    @Column(name = "scheduled_start")
    private LocalDateTime scheduledStart;

    @Column(name = "scheduled_end")
    private LocalDateTime scheduledEnd;

    @Column(name = "duration_minutes")
    private Integer durationMinutes;
}
