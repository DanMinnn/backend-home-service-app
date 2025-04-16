package com.danmin.home_service.service.impl;

import java.util.Date;

import org.springframework.stereotype.Service;

import com.danmin.home_service.common.AvailabilityStatus;
import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.CancelledByType;
import com.danmin.home_service.common.ReviewerType;
import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.request.ReviewDTO;
import com.danmin.home_service.dto.response.BookingDetailResponse;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Review;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.ReviewRepository;
import com.danmin.home_service.repository.ServiceRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.BookingService;
import com.danmin.home_service.service.UserTypeService;

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
    private final ReviewRepository reviewRepository;
    private final UserTypeService userTypeService;

    @Transactional(rollbackOn = Exception.class)
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

    @Transactional(rollbackOn = Exception.class)
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

        if (tasker.getAvailabilityStatus().name().equals("available")) {
            booking.setTasker(tasker);
            booking.setBookingStatus(BookingStatus.assigned);
            tasker.setAvailabilityStatus(AvailabilityStatus.busy);
            taskerRepository.save(tasker);
        }

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

        Long taskerId = booking.getTasker().getId().longValue();

        Tasker tasker = taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

        booking.setBookingStatus(BookingStatus.cancelled);
        booking.setCancelledByType(CancelledByType.user);
        booking.setCancellationReason(cancelReason);
        tasker.setAvailabilityStatus(AvailabilityStatus.available);

        taskerRepository.save(tasker);
        bookingRepository.save(booking);
    }

    @Override
    public void completedJob(long bookingId) {
        Bookings booking = getBookingById(bookingId);

        Long taskerId = booking.getTasker().getId().longValue();

        Tasker tasker = taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

        booking.setCompletedAt(new Date());
        booking.setBookingStatus(BookingStatus.completed);
        tasker.setAvailabilityStatus(AvailabilityStatus.available);

        taskerRepository.save(tasker);

        bookingRepository.save(booking);
    }

    @Transactional(rollbackOn = Exception.class)
    @Override
    public void rating(ReviewDTO req) {

        Bookings booking = getBookingById(req.getBookingId());

        var user = userTypeService.findById(req.getReviewerId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + req.getReviewerId()));

        ReviewerType reviewerType;

        if (user instanceof User) {
            reviewerType = ReviewerType.user;
        } else {
            reviewerType = ReviewerType.tasker;
        }

        Review review = Review.builder()
                .booking(booking)
                .reviewerId(req.getReviewerId())
                .reviewerType(reviewerType)
                .comment(req.getComment())
                .rating(req.getRating())
                .build();

        reviewRepository.save(review);

    }
}
