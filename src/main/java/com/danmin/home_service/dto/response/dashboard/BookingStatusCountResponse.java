package com.danmin.home_service.dto.response.dashboard;

import com.danmin.home_service.common.BookingStatus;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookingStatusCountResponse {
    private BookingStatus status;
    private Long count;

    public BookingStatusCountResponse() {
    }

    public BookingStatusCountResponse(BookingStatus status, Long count) {
        this.status = status;
        this.count = count;
    }

    public BookingStatus getStatus() {
        return status;
    }

    public void setStatus(BookingStatus status) {
        this.status = status;
    }

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }
}
