package com.danmin.home_service.service;

import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.request.ReviewDTO;
import com.danmin.home_service.dto.response.BookingDetailResponse;

public interface BookingService {

    void createBooking(BookingDTO req);

    void assignTasker(long bookingId, long taskerId);

    BookingDetailResponse getBookingDetail(long bookingId);

    void cancelBookings(long bookingId, String cancelReason);

    void completedJob(long bookingId);

    void rating(ReviewDTO req);
}
