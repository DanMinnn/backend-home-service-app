package com.danmin.home_service.service;

import java.time.LocalDate;
import java.util.List;

import com.danmin.home_service.dto.response.BookingDetailResponse;
import com.danmin.home_service.dto.response.dashboard.BookingStatusCountResponse;
import com.danmin.home_service.dto.response.dashboard.BookingTrendResponse;
import com.danmin.home_service.dto.response.dashboard.CompletedTasksResponse;
import com.danmin.home_service.dto.response.dashboard.DashboardResponse;
import com.danmin.home_service.dto.response.dashboard.RevenueServiceResponse;
import com.danmin.home_service.dto.response.dashboard.TopServiceResponse;
import com.danmin.home_service.dto.response.dashboard.TopTaskerResponse;
import com.danmin.home_service.dto.response.dashboard.UserRegistrationResponse;

public interface DashboardService {

    DashboardResponse getDashboardSummary();

    CompletedTasksResponse getCompletedTasksCount(LocalDate fromDate, LocalDate toDate);

    Long getPendingBookingsCount();

    UserRegistrationResponse getUserRegistrationsCount(LocalDate fromDate, LocalDate toDate);

    List<BookingTrendResponse> getBookingTrends(LocalDate fromDate, LocalDate toDate);

    List<TopServiceResponse> getMostBookedServices(LocalDate fromDate, LocalDate toDate, int limit);

    List<BookingStatusCountResponse> getBookingStatusDistribution(LocalDate fromDate, LocalDate toDate);

    List<BookingDetailResponse> getRecentBookings(int limit);

    List<TopTaskerResponse> getTopTaskers(int limit);

    RevenueServiceResponse getServiceRevenue(LocalDate fromDate, LocalDate toDate);

    // List<ServiceRevenueTimeBasedResponse> getWeeklyServiceRevenue(LocalDate
    // fromDate, LocalDate toDate);

    // List<ServiceRevenueTimeBasedResponse> getMonthlyServiceRevenue(LocalDate
    // fromDate, LocalDate toDate);

    // ServiceRevenueResponse getSpecificServiceRevenue(Long serviceId, LocalDate
    // fromDate, LocalDate toDate);
}
