package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.request.ReviewDTO;
import com.danmin.home_service.dto.response.BookingDetailResponse;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.service.BookingService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

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
    @PostMapping("/")
    public ResponseData<?> createBooking(@RequestBody BookingDTO req) {

        log.info("Booking service is started");

        try {
            bookingService.createBooking(req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Booked successfully");

        } catch (Exception e) {
            log.error("Booked failure", e);
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Can not create booking");
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

    @Operation(summary = "Booking details")
    @GetMapping("/booking-detail/{bookingId}")

    public ResponseData<BookingDetailResponse> getBookingDetail(@PathVariable(value = "bookingId") Long bookingId) {

        log.info("Getting booking detail with booking id={}", bookingId);

        try {
            return new ResponseData<>(HttpStatus.OK.value(), "Booking detail",
                    bookingService.getBookingDetail(bookingId));
        } catch (ResourceNotFoundException e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }

    }

    @Operation(summary = "Cancel booking by user")
    @PutMapping("/cancel-booking/{bookingId}")

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
    @PutMapping("/cancel-booking/{bookingId}")

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
