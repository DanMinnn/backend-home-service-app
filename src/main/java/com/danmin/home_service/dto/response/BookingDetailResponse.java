package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

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
    private Long serviceId;
    private Integer userId;
    private Integer taskerId;
    private LocalDateTime scheduledStart;
    private LocalDateTime scheduledEnd;
    private Integer duration;
    private String status;
    private Map<String, Object> taskDetails;
    private BigDecimal totalPrice;
    private String notes;
    private String username;
    private String cancelBy;
    private String cancelReason;
    private String phoneNumber;
    private String serviceName;
    private String taskerName;
    private String taskerPhone;
    private String taskerImage;
    private String paymentStatus;
    private String address;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private LocalDateTime completedAt;

}
