package com.danmin.home_service.service;

import java.io.UnsupportedEncodingException;

import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.request.ReviewDTO;
import com.danmin.home_service.dto.response.PageResponse;

import jakarta.servlet.http.HttpServletRequest;

public interface BookingService {

    Object createBooking(BookingDTO req, HttpServletRequest request)
            throws UnsupportedEncodingException;

    void assignTasker(long bookingId, long taskerId);

    PageResponse<?> getBookingDetail(int pageNo, int pageSize, Integer userId);

    void cancelBookingByUser(long bookingId, String cancelReason);

    void cancelBookingByTasker(long bookingId, String cancelReason);

    void completedJob(long bookingId);

    void rating(ReviewDTO req);
}
