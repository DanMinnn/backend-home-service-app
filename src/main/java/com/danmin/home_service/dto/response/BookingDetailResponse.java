package com.danmin.home_service.dto.response;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class BookingDetailResponse implements Serializable {

    private Long bookingId;
    private String scheduleDate;
    private String status;
    private String workLoad;
    private Double totalPrice;
    private String duration;
    private String username;
    private String cancelBy;
    private String cancelReason;
    private String phoneNumber;
    private String serviceName;
    private String taskerName;
    private String taskerPhone;

}
