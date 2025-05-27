package com.danmin.home_service.dto.request;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.CancelledByType;
import com.danmin.home_service.common.MethodType;
import com.danmin.home_service.dto.validator.EnumPattern;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;

@Getter
public class BookingDTO implements Serializable {

    private Long userId;

    private Long taskerId;

    private Long serviceId;

    private Long packageId;

    private String address;

    private LocalDateTime scheduledStart;
    private LocalDateTime scheduledEnd;
    private Integer durationMinutes;

    private Map<String, Object> taskDetails;

    private BigDecimal totalPrice;

    @NotNull(message = "type must be not null")
    @EnumPattern(name = "booking_status", regexp = "pending|assigned|in_progress|completed|cancelled|rescheduled")
    private BookingStatus bookingStatus;

    private String notes;

    private String cancellationReason;

    @EnumPattern(name = "cancelled_by", regexp = "user|tasker|admin")
    private CancelledByType cancelledByType;

    private Boolean isRecurring;

    private String recurringPattern;

    private BigDecimal longitude;

    private BigDecimal latitude;

    private MethodType methodType;
}
