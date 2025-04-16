package com.danmin.home_service.dto.request;

import java.io.Serializable;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.CancelledByType;
import com.danmin.home_service.dto.validator.EnumPattern;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;

@Getter
public class BookingDTO implements Serializable {

    private Long userId;

    private Long taskerId;

    private Long serviceId;

    private String address;

    private String scheduledDate;

    private String duration;

    private String workLoad;

    private Double totalPrice;

    @NotNull(message = "type must be not null")
    @EnumPattern(name = "booking_status", regexp = "pending|assigned|in_progress|completed|cancelled|rescheduled")
    private BookingStatus bookingStatus;

    private String notes;

    private String cancellationReason;

    @EnumPattern(name = "cancelled_by", regexp = "user|tasker|admin")
    private CancelledByType cancelledByType;

    private Boolean isRecurring;

    private String recurringPattern;
}
