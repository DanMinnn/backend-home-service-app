package com.danmin.home_service.dto.response.dashboard;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BookingTrendResponse {
    private LocalDateTime timePoint;
    private Long count;

    // Default constructor
    public BookingTrendResponse() {
    }

    public BookingTrendResponse(Object timePoint, Long bookingCount) {
        if (timePoint instanceof Timestamp) {
            this.timePoint = ((Timestamp) timePoint).toLocalDateTime();
        } else if (timePoint instanceof LocalDateTime) {
            this.timePoint = (LocalDateTime) timePoint;
        } else if (timePoint != null) {
            // Handle other possible types
            this.timePoint = LocalDateTime.parse(timePoint.toString());
        }
        this.count = bookingCount;
    }

    // // Constructor for JPA projection
    // public BookingTrendResponse(LocalDateTime timestamp, Long count) {
    // this.timestamp = timestamp;
    // this.count = count;
    // }

    // Getters and setters
    public LocalDateTime getTimestamp() {
        return timePoint;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timePoint = timestamp;
    }

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }
}
