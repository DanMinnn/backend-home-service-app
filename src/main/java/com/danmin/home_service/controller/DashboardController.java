package com.danmin.home_service.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.dto.response.dashboard.DashboardResponse;
import com.danmin.home_service.service.DashboardService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j(topic = "DASHBOARD-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Dashboard Controller")
@RequestMapping("/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Operation(summary = "Get dashboard summary data")
    @GetMapping("/summary")
    public ResponseData<DashboardResponse> getDashboardSummary() {
        try {
            DashboardResponse dashboard = dashboardService.getDashboardSummary();
            return new ResponseData<>(HttpStatus.OK.value(), "Dashboard summary retrieved successfully", dashboard);
        } catch (Exception e) {
            log.error("Error retrieving dashboard summary", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving dashboard summary: " + e.getMessage());
        }
    }

    @Operation(summary = "Get completed tasks count")
    @GetMapping("/completed-tasks")
    public ResponseData<?> getCompletedTasksCount(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate) {

        try {
            LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter) : null;
            LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) : null;

            return new ResponseData<>(HttpStatus.OK.value(),
                    "Completed tasks count retrieved successfully",
                    dashboardService.getCompletedTasksCount(from, to));
        } catch (DateTimeParseException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(),
                    "Invalid date format. Please use yyyy-MM-dd format.");
        } catch (Exception e) {
            log.error("Error retrieving completed tasks count", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving completed tasks count: " + e.getMessage());
        }
    }

    @Operation(summary = "Get pending bookings count")
    @GetMapping("/pending-bookings")
    public ResponseData<?> getPendingBookingsCount() {
        try {
            return new ResponseData<>(HttpStatus.OK.value(),
                    "Pending bookings count retrieved successfully",
                    dashboardService.getPendingBookingsCount());
        } catch (Exception e) {
            log.error("Error retrieving pending bookings count", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving pending bookings count: " + e.getMessage());
        }
    }

    @Operation(summary = "Get user registrations count")
    @GetMapping("/user-registrations")
    public ResponseData<?> getUserRegistrationsCount(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate) {

        try {
            LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter) : null;
            LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) : null;

            return new ResponseData<>(HttpStatus.OK.value(),
                    "User registrations count retrieved successfully",
                    dashboardService.getUserRegistrationsCount(from, to));
        } catch (DateTimeParseException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(),
                    "Invalid date format. Please use yyyy-MM-dd format.");
        } catch (Exception e) {
            log.error("Error retrieving user registrations count", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving user registrations count: " + e.getMessage());
        }
    }

    @Operation(summary = "Get booking trends")
    @GetMapping("/booking-trends")
    public ResponseData<?> getBookingTrends(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate) {

        try {
            LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter) : null;
            LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) : null;

            return new ResponseData<>(HttpStatus.OK.value(),
                    "Booking trends retrieved successfully",
                    dashboardService.getBookingTrends(from, to));
        } catch (DateTimeParseException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(),
                    "Invalid date format. Please use yyyy-MM-dd format.");
        } catch (Exception e) {
            log.error("Error retrieving booking trends", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving booking trends: " + e.getMessage());
        }
    }

    @Operation(summary = "Get most booked services")
    @GetMapping("/top-services")
    public ResponseData<?> getMostBookedServices(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(defaultValue = "5") int limit) {

        try {
            LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter) : null;
            LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) : null;

            return new ResponseData<>(HttpStatus.OK.value(),
                    "Top services retrieved successfully",
                    dashboardService.getMostBookedServices(from, to, limit));
        } catch (DateTimeParseException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(),
                    "Invalid date format. Please use yyyy-MM-dd format.");
        } catch (Exception e) {
            log.error("Error retrieving top services", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving top services: " + e.getMessage());
        }
    }

    @Operation(summary = "Get booking status distribution")
    @GetMapping("/status-distribution")
    public ResponseData<?> getBookingStatusDistribution(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate) {

        try {
            LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter) : null;
            LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) : null;

            return new ResponseData<>(HttpStatus.OK.value(),
                    "Booking status distribution retrieved successfully",
                    dashboardService.getBookingStatusDistribution(from, to));
        } catch (DateTimeParseException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(),
                    "Invalid date format. Please use yyyy-MM-dd format.");
        } catch (Exception e) {
            log.error("Error retrieving booking status distribution", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving booking status distribution: " + e.getMessage());
        }
    }

    @Operation(summary = "Get recent bookings")
    @GetMapping("/recent-bookings")
    public ResponseData<?> getRecentBookings(@RequestParam(defaultValue = "10") int limit) {
        try {
            return new ResponseData<>(HttpStatus.OK.value(),
                    "Recent bookings retrieved successfully",
                    dashboardService.getRecentBookings(limit));
        } catch (Exception e) {
            log.error("Error retrieving recent bookings", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving recent bookings: " + e.getMessage());
        }
    }

    @Operation(summary = "Get top taskers")
    @GetMapping("/top-taskers")
    public ResponseData<?> getTopTaskers(@RequestParam(defaultValue = "5") int limit) {
        try {
            return new ResponseData<>(HttpStatus.OK.value(),
                    "Top taskers retrieved successfully",
                    dashboardService.getTopTaskers(limit));
        } catch (Exception e) {
            log.error("Error retrieving top taskers", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving top taskers: " + e.getMessage());
        }
    }

    @Operation(summary = "Get service revenue")
    @GetMapping("/service-revenue")
    public ResponseData<?> getServiceRevenue(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate) {

        try {
            LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter) : null;
            LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) : null;

            return new ResponseData<>(HttpStatus.OK.value(),
                    "Service revenue data retrieved successfully",
                    dashboardService.getServiceRevenue(from, to));
        } catch (DateTimeParseException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(),
                    "Invalid date format. Please use yyyy-MM-dd format.");
        } catch (Exception e) {
            log.error("Error retrieving service revenue data", e);
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error retrieving service revenue data: " + e.getMessage());
        }
    }

    // @Operation(summary = "Get weekly service revenue")
    // @GetMapping("/weekly-service-revenue")
    // public ResponseData<?> getWeeklyServiceRevenue(
    // @RequestParam(required = false) String fromDate,
    // @RequestParam(required = false) String toDate) {

    // try {
    // LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter)
    // : null;
    // LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) :
    // null;

    // return new ResponseData<>(HttpStatus.OK.value(),
    // "Weekly service revenue data retrieved successfully",
    // dashboardService.getWeeklyServiceRevenue(from, to));
    // } catch (DateTimeParseException e) {
    // return new ResponseError(HttpStatus.BAD_REQUEST.value(),
    // "Invalid date format. Please use yyyy-MM-dd format.");
    // } catch (Exception e) {
    // log.error("Error retrieving weekly service revenue data", e);
    // return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
    // "Error retrieving weekly service revenue data: " + e.getMessage());
    // }
    // }

    // @Operation(summary = "Get monthly service revenue")
    // @GetMapping("/monthly-service-revenue")
    // public ResponseData<?> getMonthlyServiceRevenue(
    // @RequestParam(required = false) String fromDate,
    // @RequestParam(required = false) String toDate) {

    // try {
    // LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter)
    // : null;
    // LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) :
    // null;

    // return new ResponseData<>(HttpStatus.OK.value(),
    // "Monthly service revenue data retrieved successfully",
    // dashboardService.getMonthlyServiceRevenue(from, to));
    // } catch (DateTimeParseException e) {
    // return new ResponseError(HttpStatus.BAD_REQUEST.value(),
    // "Invalid date format. Please use yyyy-MM-dd format.");
    // } catch (Exception e) {
    // log.error("Error retrieving monthly service revenue data", e);
    // return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
    // "Error retrieving monthly service revenue data: " + e.getMessage());
    // }
    // }

    // @Operation(summary = "Get revenue for a specific service")
    // @GetMapping("/service/{serviceId}/revenue")
    // public ResponseData<?> getSpecificServiceRevenue(
    // @PathVariable Long serviceId,
    // @RequestParam(required = false) String fromDate,
    // @RequestParam(required = false) String toDate) {

    // try {
    // LocalDate from = fromDate != null ? LocalDate.parse(fromDate, dateFormatter)
    // : null;
    // LocalDate to = toDate != null ? LocalDate.parse(toDate, dateFormatter) :
    // null;

    // return new ResponseData<>(HttpStatus.OK.value(),
    // "Service revenue data retrieved successfully",
    // dashboardService.getSpecificServiceRevenue(serviceId, from, to));
    // } catch (DateTimeParseException e) {
    // return new ResponseError(HttpStatus.BAD_REQUEST.value(),
    // "Invalid date format. Please use yyyy-MM-dd format.");
    // } catch (Exception e) {
    // log.error("Error retrieving service revenue data", e);
    // return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(),
    // "Error retrieving service revenue data: " + e.getMessage());
    // }
    // }
}
