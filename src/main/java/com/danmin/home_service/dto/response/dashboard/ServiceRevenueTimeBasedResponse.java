package com.danmin.home_service.dto.response.dashboard;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ServiceRevenueTimeBasedResponse {
    private Long serviceId;
    private String serviceName;
    private String categoryName;
    private LocalDateTime timePeriod;
    private BigDecimal totalRevenue;
    private Long bookingCount;

    public ServiceRevenueTimeBasedResponse() {
    }

    public ServiceRevenueTimeBasedResponse(Long serviceId, String serviceName, String categoryName,
            LocalDateTime timePeriod, BigDecimal totalRevenue, Long bookingCount) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.categoryName = categoryName;
        this.timePeriod = timePeriod;
        this.totalRevenue = totalRevenue;
        this.bookingCount = bookingCount;
    }
}
