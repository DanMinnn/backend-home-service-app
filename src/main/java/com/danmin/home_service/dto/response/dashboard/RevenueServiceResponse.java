package com.danmin.home_service.dto.response.dashboard;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RevenueServiceResponse {
    private List<ServiceRevenueResponse> totalRevenues;
    private List<ServiceRevenueResponse> totalRevenuesToday;
    private List<ServiceRevenueResponse> totalRevenuesThisWeek;
    private List<ServiceRevenueResponse> totalRevenuesThisMonth;

    public RevenueServiceResponse(List<ServiceRevenueResponse> totalRevenues,
            List<ServiceRevenueResponse> totalRevenuesToday, List<ServiceRevenueResponse> totalRevenuesThisWeek,
            List<ServiceRevenueResponse> totalRevenuesThisMonth) {
        this.totalRevenues = totalRevenues;
        this.totalRevenuesToday = totalRevenuesToday;
        this.totalRevenuesThisWeek = totalRevenuesThisWeek;
        this.totalRevenuesThisMonth = totalRevenuesThisMonth;
    }

}
