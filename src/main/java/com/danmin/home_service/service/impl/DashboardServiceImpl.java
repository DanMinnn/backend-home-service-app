package com.danmin.home_service.service.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.response.BookingDetailResponse;
import com.danmin.home_service.dto.response.dashboard.BookingStatusCountResponse;
import com.danmin.home_service.dto.response.dashboard.BookingTrendResponse;
import com.danmin.home_service.dto.response.dashboard.CompletedTasksResponse;
import com.danmin.home_service.dto.response.dashboard.DashboardResponse;
import com.danmin.home_service.dto.response.dashboard.RevenueServiceResponse;
import com.danmin.home_service.dto.response.dashboard.ServiceRevenueResponse;
import com.danmin.home_service.dto.response.dashboard.TopServiceResponse;
import com.danmin.home_service.dto.response.dashboard.TopTaskerResponse;
import com.danmin.home_service.dto.response.dashboard.UserRegistrationResponse;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.repository.DashboardRepository;
import com.danmin.home_service.service.DashboardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "DASHBOARD-SERVICE")
public class DashboardServiceImpl implements DashboardService {

        private final DashboardRepository dashboardRepository;
        private final BookingServiceImpl bookingServiceImpl;

        @Override
        public DashboardResponse getDashboardSummary() {
                LocalDate today = LocalDate.now();

                DashboardResponse dashboardResponse = new DashboardResponse(
                                getCompletedTasksCount(today.minusMonths(1), today),
                                getPendingBookingsCount(),
                                getUserRegistrationsCount(today.minusMonths(1), today),
                                getBookingTrends(today.minusWeeks(1), today),
                                getMostBookedServices(today.minusMonths(1), today, 5),
                                getBookingStatusDistribution(today.minusMonths(1), today),
                                getRecentBookings(10), getTopTaskers(5),
                                getServiceRevenue(today.minusMonths(1), today));

                return dashboardResponse;
        }

        @Override
        public CompletedTasksResponse getCompletedTasksCount(LocalDate fromDate, LocalDate toDate) {
                LocalDate today = LocalDate.now();
                LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
                LocalDate startOfMonth = today.withDayOfMonth(1);

                LocalDateTime fromDateTime = fromDate != null ? fromDate.atStartOfDay()
                                : today.minusMonths(1).atStartOfDay();
                LocalDateTime toDateTime = toDate != null ? toDate.atTime(LocalTime.MAX) : today.atTime(LocalTime.MAX);

                Long totalCompletedTasks = dashboardRepository.countCompletedTasksByDateRange(
                                fromDateTime, toDateTime);
                Long completedTasksToday = dashboardRepository.countCompletedTasksByDateRange(
                                today.atStartOfDay(), today.atTime(LocalTime.MAX));
                Long completedTasksThisWeek = dashboardRepository.countCompletedTasksByDateRange(
                                startOfWeek.atStartOfDay(), today.atTime(LocalTime.MAX));
                Long completedTasksThisMonth = dashboardRepository.countCompletedTasksByDateRange(
                                startOfMonth.atStartOfDay(), today.atTime(LocalTime.MAX));

                CompletedTasksResponse completedTasksResponse = new CompletedTasksResponse(totalCompletedTasks,
                                completedTasksToday, completedTasksThisWeek, completedTasksThisMonth);
                return completedTasksResponse;
        }

        @Override
        public Long getPendingBookingsCount() {
                return dashboardRepository.countPendingBookings();
        }

        @Override
        public UserRegistrationResponse getUserRegistrationsCount(LocalDate fromDate, LocalDate toDate) {
                LocalDate today = LocalDate.now();
                LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
                LocalDate startOfMonth = today.withDayOfMonth(1);

                // Get total counts
                Long totalClients = dashboardRepository.countTotalUsers();
                Long totalTaskers = dashboardRepository.countTotalTaskers();

                // Get new registrations
                Long newUsersToday = dashboardRepository.countUserRegistrationsByDateRange(
                                today.atStartOfDay(), today.atTime(LocalTime.MAX));
                Long newUsersThisWeek = dashboardRepository.countUserRegistrationsByDateRange(
                                startOfWeek.atStartOfDay(), today.atTime(LocalTime.MAX));
                Long newUsersThisMonth = dashboardRepository.countUserRegistrationsByDateRange(
                                startOfMonth.atStartOfDay(), today.atTime(LocalTime.MAX));

                UserRegistrationResponse userRegistrationResponse = new UserRegistrationResponse(
                                totalClients,
                                totalTaskers, newUsersToday + dashboardRepository.countTaskerRegistrationsByDateRange(
                                                today.atStartOfDay(), today.atTime(LocalTime.MAX)),
                                newUsersThisWeek + dashboardRepository.countTaskerRegistrationsByDateRange(
                                                startOfWeek.atStartOfDay(), today.atTime(LocalTime.MAX)),
                                newUsersThisMonth + dashboardRepository.countTaskerRegistrationsByDateRange(
                                                startOfMonth.atStartOfDay(), today.atTime(LocalTime.MAX)));

                return userRegistrationResponse;
        }

        @Override
        public List<BookingTrendResponse> getBookingTrends(LocalDate fromDate, LocalDate toDate) {
                LocalDate today = LocalDate.now();
                LocalDateTime fromDateTime = fromDate != null ? fromDate.atStartOfDay()
                                : today.minusWeeks(1).atStartOfDay();
                LocalDateTime toDateTime = toDate != null ? toDate.atTime(LocalTime.MAX) : today.atTime(LocalTime.MAX);

                return dashboardRepository.getBookingTrendsByInterval(fromDateTime, toDateTime);
        }

        @Override
        public List<TopServiceResponse> getMostBookedServices(LocalDate fromDate, LocalDate toDate, int limit) {
                LocalDate today = LocalDate.now();
                LocalDateTime fromDateTime = fromDate != null ? fromDate.atStartOfDay()
                                : today.minusMonths(1).atStartOfDay();
                LocalDateTime toDateTime = toDate != null ? toDate.atTime(LocalTime.MAX) : today.atTime(LocalTime.MAX);

                return dashboardRepository.getMostBookedServices(fromDateTime, toDateTime, limit);
        }

        @Override
        public List<BookingStatusCountResponse> getBookingStatusDistribution(LocalDate fromDate, LocalDate toDate) {
                LocalDate today = LocalDate.now();
                LocalDateTime fromDateTime = fromDate != null ? fromDate.atStartOfDay()
                                : today.minusMonths(1).atStartOfDay();
                LocalDateTime toDateTime = toDate != null ? toDate.atTime(LocalTime.MAX) : today.atTime(LocalTime.MAX);

                return dashboardRepository.getBookingStatusDistribution(fromDateTime, toDateTime);
        }

        @Override
        public List<BookingDetailResponse> getRecentBookings(int limit) {
                PageRequest pageRequest = PageRequest.of(0, limit);
                List<Bookings> recentBookings = dashboardRepository.findRecentBookings(pageRequest);
                return bookingServiceImpl.bookingDetailResponses(recentBookings);
        }

        @Override
        public List<TopTaskerResponse> getTopTaskers(int limit) {
                PageRequest pageRequest = PageRequest.of(0, limit);
                return dashboardRepository.findTopTaskers(pageRequest);
        }

        @Override
        public RevenueServiceResponse getServiceRevenue(LocalDate fromDate, LocalDate toDate) {
                LocalDate today = LocalDate.now();
                LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
                LocalDate startOfMonth = today.withDayOfMonth(1);

                LocalDateTime fromDateTime = fromDate != null ? fromDate.atStartOfDay()
                                : today.minusMonths(1).atStartOfDay();
                LocalDateTime toDateTime = toDate != null ? toDate.atTime(LocalTime.MAX) : today.atTime(LocalTime.MAX);

                List<ServiceRevenueResponse> totalRevenues = dashboardRepository.calculateServiceRevenue(fromDateTime,
                                toDateTime);
                List<ServiceRevenueResponse> totalRevenuesToday = dashboardRepository
                                .calculateServiceRevenue(today.atStartOfDay(), today.atTime(LocalTime.MAX));
                List<ServiceRevenueResponse> totalRevenuesThisWeek = dashboardRepository
                                .calculateServiceRevenue(startOfWeek.atStartOfDay(), today.atTime(LocalTime.MAX));
                List<ServiceRevenueResponse> totalRevenuesThisMonth = dashboardRepository
                                .calculateServiceRevenue(startOfMonth.atStartOfDay(), today.atTime(LocalTime.MAX));

                RevenueServiceResponse revenueServiceResponse = new RevenueServiceResponse(totalRevenues,
                                totalRevenuesToday, totalRevenuesThisWeek, totalRevenuesThisMonth);
                return revenueServiceResponse;
        }
}
