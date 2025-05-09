package com.danmin.home_service.service.impl;

import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.danmin.home_service.common.AvailabilityStatus;
import com.danmin.home_service.common.BookingStatus;
import com.danmin.home_service.common.CancelledByType;
import com.danmin.home_service.common.MethodType;
import com.danmin.home_service.common.PaymentStatus;
import com.danmin.home_service.common.ReviewerType;
import com.danmin.home_service.dto.request.BookingDTO;
import com.danmin.home_service.dto.request.ReviewDTO;
import com.danmin.home_service.dto.response.BookingDetailResponse;
import com.danmin.home_service.exception.BusinessException;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Payments;
import com.danmin.home_service.model.Review;
import com.danmin.home_service.model.ServicePackages;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.PaymentRepository;
import com.danmin.home_service.repository.ReviewRepository;
import com.danmin.home_service.repository.ServicePackageRepository;
import com.danmin.home_service.repository.ServiceRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.BookingService;
import com.danmin.home_service.service.PaymentService;
import com.danmin.home_service.service.TaskerWalletService;
import com.danmin.home_service.service.UserWalletService;
import com.danmin.home_service.service.UserTypeService;

import jakarta.servlet.http.HttpServletRequest;
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

    private final TaskerWalletService taskerWalletService;
    private final UserWalletService userWalletService;
    private final PaymentService paymentService;
    private final PaymentRepository paymentRepository;

    private final ServicePackageRepository servicePackageRepository;

    @Transactional(rollbackOn = Exception.class)
    @Override
    public Object createBooking(BookingDTO req, HttpServletRequest request)
            throws UnsupportedEncodingException {

        User user = userRepository.findById(req.getUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + req.getUserId()));

        Services services = serviceRepository.findById(req.getServiceId())
                .orElseThrow(() -> new ResourceNotFoundException("Service not found with id: " + req.getServiceId()));

        ServicePackages servicesPackage = servicePackageRepository.findById(req.getPackageId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Service package not found with id: " + req.getPackageId()));

        String transactionId = String.valueOf(System.currentTimeMillis());

        Bookings bookings = Bookings.builder()
                .user(user)
                .service(services)
                .packages(servicesPackage)
                .address(req.getAddress())
                .duration(req.getDuration())
                .scheduledDate(req.getScheduledDate())
                .taskDetails(req.getTaskDetails())
                .totalPrice(req.getTotalPrice())
                .notes(req.getNotes())
                .longitude(req.getLongitude())
                .latitude(req.getLatitude())
                .bookingStatus(BookingStatus.pending)
                .paymentStatus("unpaid")
                .cancellationReason(req.getCancellationReason())
                .cancelledByType(req.getCancelledByType())
                .build();

        if (req.getMethodType() == MethodType.bank_transfer) {

            bookingRepository.save(bookings);
            userWalletService.debitAccount(user.getId().longValue(), bookings.getTotalPrice());

            paymentRepository.save(Payments.builder()
                    .booking(bookings)
                    .user(bookings.getUser())
                    .tasker(bookings.getTasker())
                    .amount(bookings.getTotalPrice())
                    .currency("VND")
                    .methodType(MethodType.bank_transfer)
                    .status(PaymentStatus.completed)
                    .transactionId(transactionId)
                    .paymentGateway(MethodType.bank_transfer.toString()).build());

            bookings.setPaymentStatus("paid");
            bookingRepository.save(bookings);

            Map<String, Object> response = new HashMap<>();
            response.put("bookingId", bookings.getId());
            response.put("status", "confirmed");
            response.put("message", "Booking created and payment processed successfully");

            return response;
        } else if (req.getMethodType() == MethodType.vnpay) {
            bookingRepository.save(bookings);
            String paymentUrl = paymentService.createPaymentUrl(request, bookings.getId());

            Map<String, String> response = new HashMap<>();
            response.put("paymentUrl", paymentUrl);

            bookings.setPaymentStatus("paid");
            bookingRepository.save(bookings);

            return response;
        } else {
            bookingRepository.save(bookings);

            Map<String, Object> response = new HashMap<>();
            response.put("bookingId", bookings.getId());
            response.put("status", "unpaid");
            response.put("message", "Booking created and payment processed successfully");

            return response;
        }

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

        if (tasker.getAvailabilityStatus().name().equals("available")
                && taskerWalletService.checkBalanceAccount(taskerId, bookingId)) {
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
                .taskDetails(booking.getTaskDetails())
                .totalPrice(booking.getTotalPrice())
                .duration(booking.getDuration())
                .cancelBy(booking.getCancelledByType().name())
                .cancelReason(booking.getCancellationReason())
                .status(booking.getBookingStatus().name())
                .paymentStatus(booking.getPaymentStatus())
                .build();

        if (booking.getTasker() != null) {
            bookingDetail.setTaskerName(booking.getTasker().getFirstLastName());
            bookingDetail.setTaskerPhone(booking.getTasker().getPhoneNumber());
        }

        return bookingDetail;

    }

    @Override
    public void cancelBookingByUser(long bookingId, String cancelReason) {

        Bookings booking = getBookingById(bookingId);

        if (booking.getBookingStatus().equals(BookingStatus.assigned)) {

            Long taskerId = booking.getTasker().getId().longValue();
            Tasker tasker = taskerRepository.findById(taskerId)
                    .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

            tasker.setAvailabilityStatus(AvailabilityStatus.available);
            taskerRepository.save(tasker);
        }

        userWalletService.refund(booking.getId());

        booking.setBookingStatus(BookingStatus.cancelled);
        booking.setCancelledByType(CancelledByType.user);
        booking.setCancellationReason(cancelReason);
        booking.setUpdatedAt(LocalDateTime.now());
        bookingRepository.save(booking);

    }

    @Override
    public void cancelBookingByTasker(long bookingId, String cancelReason) {

        Bookings booking = getBookingById(bookingId);

        Long taskerId = booking.getTasker().getId().longValue();

        Tasker tasker = taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

        // Check cancellations in the last 7 days
        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        int cancelCount = bookingRepository.countCancelledBookingsByTaskerInLast7Days(taskerId, sevenDaysAgo);

        if (cancelCount >= 2) {
            throw new BusinessException(
                    "You have exceeded the limit of 2 cancellations in 7 days. This job cannot be canceled.");
        }

        if (cancelCount == 1) {
            log.warn("Tasker [{}] is canceling its 2nd job in 7 days. This is the last cancellation allowed.",
                    taskerId);
        }

        booking.setBookingStatus(BookingStatus.cancelled);
        booking.setCancelledByType(CancelledByType.tasker);
        booking.setCancellationReason(cancelReason);
        booking.setUpdatedAt(LocalDateTime.now());
        bookingRepository.save(booking);

        tasker.setAvailabilityStatus(AvailabilityStatus.available);
        taskerRepository.save(tasker);

    }

    @Override
    public void completedJob(long bookingId) {
        Bookings booking = getBookingById(bookingId);

        Long taskerId = booking.getTasker().getId().longValue();

        Tasker tasker = taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

        booking.setCompletedAt(new Date());
        booking.setBookingStatus(BookingStatus.completed);
        booking.setPaymentStatus("paid");
        bookingRepository.save(booking);

        tasker.setAvailabilityStatus(AvailabilityStatus.available);
        taskerRepository.save(tasker);

        taskerWalletService.incomeCompleteTask(booking.getId(), taskerId);

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
