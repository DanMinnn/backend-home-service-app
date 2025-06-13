package com.danmin.home_service.dto.response.dashboard;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ServiceRevenueResponse {
    private Long serviceId;
    private String serviceName;
    private String categoryName;
    private BigDecimal totalRevenue;
    private Long bookingCount;
    
    public ServiceRevenueResponse() {
    }
    
    public ServiceRevenueResponse(Long serviceId, String serviceName, String categoryName, BigDecimal totalRevenue, Long bookingCount) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.categoryName = categoryName;
        this.totalRevenue = totalRevenue;
        this.bookingCount = bookingCount;
    }
}
