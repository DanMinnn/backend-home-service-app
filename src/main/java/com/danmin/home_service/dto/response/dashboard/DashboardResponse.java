package com.danmin.home_service.dto.response.dashboard;

import java.util.List;

import com.danmin.home_service.dto.response.BookingDetailResponse;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DashboardResponse {
    private CompletedTasksResponse completedTasks;
    private Long pendingBookingsCount;
    private UserRegistrationResponse userRegistrations;
    private List<BookingTrendResponse> bookingTrends;
    private List<TopServiceResponse> topServices;
    private List<BookingStatusCountResponse> bookingStatusDistribution;
    private List<BookingDetailResponse> recentBookings;
    private List<TopTaskerResponse> topTaskers;
    private RevenueServiceResponse revenueServices;

    public DashboardResponse(CompletedTasksResponse completedTasks, Long pendingBookingsCount,
            UserRegistrationResponse userRegistrations, List<BookingTrendResponse> bookingTrends,
            List<TopServiceResponse> topServices, List<BookingStatusCountResponse> bookingStatusDistribution,
            List<BookingDetailResponse> recentBookings, List<TopTaskerResponse> topTaskers,
            RevenueServiceResponse revenueServices) {
        this.completedTasks = completedTasks;
        this.pendingBookingsCount = pendingBookingsCount;
        this.userRegistrations = userRegistrations;
        this.bookingTrends = bookingTrends;
        this.topServices = topServices;
        this.bookingStatusDistribution = bookingStatusDistribution;
        this.recentBookings = recentBookings;
        this.topTaskers = topTaskers;
        this.revenueServices = revenueServices;
    }

}
