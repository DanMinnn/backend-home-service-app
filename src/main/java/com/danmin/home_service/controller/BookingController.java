package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.request.ReviewDTO;
import com.danmin.home_service.dto.response.BookingDetailResponse;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.exception.PaymentException;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.service.BookingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@Slf4j(topic = "BOOKING-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Booking Controller")
@RequestMapping("/booking")
public class BookingController {

    private final BookingService bookingService;

    @Operation(summary = "Create booking")
    @PostMapping("/create-booking")
    public ResponseData<?> createBooking(@RequestBody BookingDTO req, HttpServletRequest httpRequest) {

        log.info("Booking service is started");

        try {
            Object result = bookingService.createBooking(req, httpRequest);

            if (result instanceof Map && ((Map<?, ?>) result).containsKey("paymentUrl")) {
                return new ResponseData(HttpStatus.ACCEPTED.value(), "Payment URL created", result);
            } else {
                return new ResponseData(HttpStatus.OK.value(), "Booking created", result);
            }
        } catch (PaymentException e) {
            log.error("Payment failed: {}", e.getMessage());
            return new ResponseError(HttpStatus.PAYMENT_REQUIRED.value(), e.getMessage());
        } catch (Exception e) {
            log.error("Booking failed", e);
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Cannot create booking: " + e.getMessage());
        }

    }

    @Operation(summary = "Assign Tasker (for tasker)")
    @PutMapping("/{bookingId}/assign-tasker")
    public ResponseData<?> assignTasker(@PathVariable(value = "bookingId") Long bookingId,
            @RequestParam(value = "taskerId") Long taskerId) {

        log.info("Assign tasker is started");

        try {
            bookingService.assignTasker(bookingId, taskerId);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Assigned tasker successfully");

        } catch (Exception e) {
            log.error("Assigned failure", e);
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Can not assign tasker");
        }

    }

    @Operation(summary = "Booking details by userId")
    @GetMapping("/{userId}/booking-detail/")
    public ResponseData<?> getBookingDetail(
            @PathVariable(value = "userId") Integer userId,
            @RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize,
            @RequestParam(required = false) String status) {

        log.info("Getting booking detail with userId={}, status={}", userId, status);

        try {
            if (status != null && !status.isEmpty()) {
                return new ResponseData<>(HttpStatus.OK.value(), "Filtered booking detail",
                        bookingService.getBookingFilteringStatus(pageNo, pageSize, userId, status));
            } else {
                return new ResponseData<>(HttpStatus.OK.value(), "Booking detail",
                        bookingService.getBookingDetail(pageNo, pageSize, userId));
            }
        } catch (ResourceNotFoundException e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        } catch (IllegalArgumentException e) {
            log.error("Invalid status value: {}", e.getMessage());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Invalid status value: " + e.getMessage());
        }
    }

    @Operation(summary = "Cancel booking by user")
    @PutMapping("/cancel-booking-by-user/{bookingId}")

    public ResponseData<BookingDetailResponse> cancelBookingByUser(@PathVariable(value = "bookingId") Long bookingId,
            @RequestParam(value = "cancelReason") String cancelReason) {

        log.info("Cancel booking with booking id={}", bookingId);

        try {
            bookingService.cancelBookingByUser(bookingId, cancelReason);

            return new ResponseData<>(HttpStatus.OK.value(), "Cancel booking successfully");
        } catch (ResourceNotFoundException e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }

    }

    @Operation(summary = "Cancel booking by tasker")
    @PutMapping("/cancel-booking-by-tasker/{bookingId}")

    public ResponseData<BookingDetailResponse> cancelBookingByTasker(@PathVariable(value = "bookingId") Long bookingId,
            @RequestParam(value = "cancelReason") String cancelReason) {

        log.info("Cancel booking with booking id={}", bookingId);

        try {
            bookingService.cancelBookingByTasker(bookingId, cancelReason);

            return new ResponseData<>(HttpStatus.OK.value(), "Cancel booking successfully");
        } catch (ResourceNotFoundException e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }

    }

    @Operation(summary = "Completed booking job")
    @PutMapping("/completed-booking/{bookingId}")

    public ResponseData<BookingDetailResponse> completedBooking(@PathVariable(value = "bookingId") Long bookingId) {

        log.info("Completing booking with booking id={}", bookingId);

        try {
            bookingService.completedJob(bookingId);

            return new ResponseData<>(HttpStatus.OK.value(), "Completed booking successfully");
        } catch (ResourceNotFoundException e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }

    }

    @Operation(summary = "Review user/tasker")
    @PostMapping("/review")

    public ResponseData<?> review(@RequestBody ReviewDTO req) {

        log.info("Reviewing with booking id={}", req.getBookingId());

        try {
            bookingService.rating(req);

            return new ResponseData<>(HttpStatus.OK.value(), "Reviewed booking successfully");
        } catch (ResourceNotFoundException e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }

    }

}
