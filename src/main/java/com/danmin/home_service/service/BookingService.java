package com.danmin.home_service.service;

import java.io.UnsupportedEncodingException;
import java.util.List;

import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.request.ReviewDTO;
import com.danmin.home_service.dto.response.PageResponse;

import jakarta.servlet.http.HttpServletRequest;

public interface BookingService {

    Object createBooking(BookingDTO req, HttpServletRequest request)
            throws UnsupportedEncodingException;

    void assignTasker(long bookingId, long taskerId);

    PageResponse<?> getBookingDetail(int pageNo, int pageSize, Integer userId);

    PageResponse<?> getBookingFilteringStatus(int pageNo, int pageSize, Integer userId, String status);

    PageResponse<?> getTaskForTasker(int pageNo, int pageSize, Long taskerId, List<Long> serviceIds);

    PageResponse<?> getTaskAssignByTaskerFollowDateTime(int pageNo, int pageSize, Long taskerId, String selectedDate);

    PageResponse<?> getHistoryTask(int pageNo, int pageSize, Integer taskerId);

    void cancelBookingByUser(long bookingId, String cancelReason);

    void cancelBookingByTasker(long bookingId, String cancelReason);

    void completedJob(long bookingId);

    void rating(ReviewDTO req);
}
