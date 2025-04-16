package com.danmin.home_service.service.impl;

import org.springframework.stereotype.Service;

import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.CancelledByType;
import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.response.BookingDetailResponse;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.ServiceRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.BookingService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "BOOKING-SERVICE")
public class BookingServiceImpl implements BookingService {

    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;
    private final ServiceRepository serviceRepository;
    private final TaskerRepository taskerRepository;

    @Transactional
    @Override
    public void createBooking(BookingDTO req) {

        User user = userRepository.findById(req.getUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + req.getUserId()));

        Services services = serviceRepository.findById(req.getServiceId())
                .orElseThrow(() -> new ResourceNotFoundException("Service not found with id: " + req.getServiceId()));

        Bookings bookings = Bookings.builder()
                .user(user)
                .service(services)
                .address(req.getAddress())
                .duration(req.getDuration())
                .scheduledDate(req.getScheduledDate())
                .workLoad(req.getWorkLoad())
                .totalPrice(req.getTotalPrice())
                .notes(req.getNotes())
                .bookingStatus(BookingStatus.pending)
                .cancellationReason(req.getCancellationReason())
                .build();

        bookingRepository.save(bookings);
    }

    private Bookings getBookingById(long bookingId) {

        return bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));
    }

    @Transactional
    @Override
    public void assignTasker(long bookingId, long taskerId) {

        Bookings booking = getBookingById(bookingId);

        Tasker tasker = taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

        Boolean hasService = tasker.getTaskerServices().stream()
                .anyMatch(ts -> ts.getService().getId().equals(booking.getService().getId()));

        if (!hasService) {
            throw new ResourceNotFoundException("Tasker does not provide this service");
        }

        booking.setTasker(tasker);
        booking.setBookingStatus(BookingStatus.assigned);

        bookingRepository.save(booking);

    }

    @Override
    public BookingDetailResponse getBookingDetail(long bookingId) {

        Bookings booking = getBookingById(bookingId);

        BookingDetailResponse bookingDetail = BookingDetailResponse.builder()
                .bookingId(bookingId)
                .username(booking.getUser().getFirstLastName())
                .phoneNumber(booking.getUser().getPhoneNumber())
                .serviceName(booking.getService().getName())
                .scheduleDate(booking.getScheduledDate())
                .workLoad(booking.getWorkLoad())
                .totalPrice(booking.getTotalPrice())
                .duration(booking.getDuration())
                .cancelBy(booking.getCancelledByType().name())
                .cancelReason(booking.getCancellationReason())
                .status(booking.getBookingStatus().name())
                .build();

        if (booking.getTasker() != null) {
            bookingDetail.setTaskerName(booking.getTasker().getFirstLastName());
            bookingDetail.setTaskerPhone(booking.getTasker().getPhoneNumber());
        }

        return bookingDetail;

    }

    @Override
    public void cancelBookings(long bookingId, String cancelReason) {

        Bookings booking = getBookingById(bookingId);

        booking.setCancelledByType(CancelledByType.user);
        booking.setCancellationReason(cancelReason);

        bookingRepository.save(booking);
    }
}
