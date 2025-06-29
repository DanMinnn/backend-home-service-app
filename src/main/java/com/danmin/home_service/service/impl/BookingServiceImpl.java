package com.danmin.home_service.service.impl;

import java.io.UnsupportedEncodingException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
import com.danmin.home_service.dto.response.PageResponse;
import com.danmin.home_service.exception.BusinessException;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Payments;
import com.danmin.home_service.model.Review;
import com.danmin.home_service.model.ServicePackages;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.TaskerExposureStats;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.PaymentRepository;
import com.danmin.home_service.repository.ReviewRepository;
import com.danmin.home_service.repository.ServicePackageRepository;
import com.danmin.home_service.repository.ServiceRepository;
import com.danmin.home_service.repository.TaskerExposureStatsRepository;
import com.danmin.home_service.repository.TaskerNotificationRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.BookingService;
import com.danmin.home_service.service.NotificationService;
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
    private final TaskerNotificationRepository taskerNotificationRepository;

    private final TaskerWalletService taskerWalletService;
    private final UserWalletService userWalletService;
    private final PaymentService paymentService;
    private final PaymentRepository paymentRepository;

    private final ServicePackageRepository servicePackageRepository;
    private final NotificationService notificationService;

    private final TaskerExposureStatsRepository taskerExposureStatsRepository;

    // =================== CREATE BOOKING METHODS ===================
    @Transactional(rollbackOn = Exception.class)
    @Override
    public Object createBooking(BookingDTO req, HttpServletRequest request)
            throws UnsupportedEncodingException {

        User user = userRepository.findById(req.getUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + req.getUserId()));

        // book with favorite tasker
        Tasker tasker;
        if (req.getTaskerId() != null) {
            tasker = taskerRepository.findById(req.getTaskerId())
                    .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + req.getTaskerId()));
        } else {
            tasker = null;
        }

        Services services = serviceRepository.findById(req.getServiceId())
                .orElseThrow(() -> new ResourceNotFoundException("Service not found with id: " + req.getServiceId()));

        ServicePackages servicesPackage = servicePackageRepository.findById(req.getPackageId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Service package not found with id: " + req.getPackageId()));

        String transactionId = "INV_" + String.valueOf(System.currentTimeMillis());

        Bookings bookings = Bookings.builder()
                .user(user)
                .tasker(tasker)
                .service(services)
                .packages(servicesPackage)
                .address(req.getAddress())
                .scheduledStart(req.getScheduledStart())
                .scheduledEnd(req.getScheduledEnd())
                .durationMinutes(req.getDurationMinutes())
                .taskDetails(req.getTaskDetails())
                .totalPrice(req.getTotalPrice())
                .notes(req.getNotes())
                .longitude(req.getLongitude())
                .latitude(req.getLatitude())
                .bookingStatus(BookingStatus.pending)
                .paymentStatus("unpaid")
                .cancellationReason(req.getCancellationReason())
                .cancelledByType(CancelledByType.completed)
                .build();

        if (req.getTaskerId() != null) {
            bookings.setBookingStatus(BookingStatus.assigned);
        }

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
            try {
                notificationService.notifyAvailableTaskers(bookings.getId());
            } catch (Exception e) {
                log.warn("Notify tasker failed", e);
            }
            Map<String, Object> response = new HashMap<>();
            response.put("bookingId", bookings.getId());
            response.put("status", "confirmed");

            return response;
        } else if (req.getMethodType() == MethodType.vnpay) {
            bookingRepository.save(bookings);
            String paymentUrl = paymentService.createPaymentUrl(request, bookings.getId());

            Map<String, String> response = new HashMap<>();
            response.put("paymentUrl", paymentUrl);

            bookings.setPaymentStatus("paid");
            bookingRepository.save(bookings);
            try {
                notificationService.notifyAvailableTaskers(bookings.getId());
            } catch (Exception e) {
                log.warn("Notify tasker failed: {}", e.getMessage());
            }
            return response;
        } else {
            bookingRepository.save(bookings);

            paymentRepository.save(Payments.builder()
                    .booking(bookings)
                    .user(bookings.getUser())
                    .tasker(bookings.getTasker())
                    .amount(bookings.getTotalPrice())
                    .currency("VND")
                    .methodType(MethodType.cash)
                    .status(PaymentStatus.pending)
                    .transactionId(transactionId)
                    .paymentGateway(MethodType.cash.toString()).build());

            try {
                notificationService.notifyAvailableTaskers(bookings.getId());
            } catch (Exception e) {
                log.warn("Notify tasker failed: {}", e.getMessage());
            }
            Map<String, Object> response = new HashMap<>();
            response.put("bookingId", bookings.getId());
            response.put("status", "unpaid");

            return response;
        }

    }

    private Bookings getBookingById(long bookingId) {

        return bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));
    }

    // =================== ASSIGN TASKER METHODS ===================
    @Transactional(rollbackOn = Exception.class)
    @Override
    public void assignTasker(long bookingId, long taskerId) {
        Bookings booking = bookingRepository.findByIdWithPessimisticLock(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        // prevent duplicate assignments
        if (booking.getTasker() != null || !booking.getBookingStatus().equals(BookingStatus.pending)) {
            throw new BusinessException("This task has already been assigned to another tasker");
        }

        Tasker tasker = taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: "
                        + taskerId));

        // Get all currently assigned bookings for this tasker
        List<Bookings> existingBookings = bookingRepository.getTaskAssignByTasker(taskerId);

        // Get start and end time from the new booking
        LocalDateTime newBookingStart = booking.getScheduledStart();
        LocalDateTime newBookingEnd = booking.getScheduledEnd();

        if (newBookingStart == null || newBookingEnd == null) {
            log.error("Booking has invalid scheduled times");
            throw new BusinessException("Invalid booking times");
        }

        // check amount of tasks
        int count = 0;
        LocalDateTime currentTime = LocalDateTime.now();
        // Check for scheduling conflicts with existing bookings
        for (Bookings existingBooking : existingBookings) {
            try {
                LocalDateTime existingStart = existingBooking.getScheduledStart();
                LocalDateTime existingEnd = existingBooking.getScheduledEnd();
                LocalDateTime existingUpdatedAt = existingBooking.getUpdatedAt();
                if (existingStart == null || existingEnd == null) {
                    log.warn("Existing booking {} has invalid scheduled times", existingBooking.getId());
                    continue;
                }

                if (existingUpdatedAt.getDayOfMonth() == currentTime.getDayOfMonth()) {
                    count++;
                }

                if (count == 3) {
                    throw new BusinessException("You can only accept a maximum of 3 jobs per day.");
                }

                // Check if there's at least 2 hours between jobs
                if ((existingEnd.plusHours(2).isAfter(newBookingStart) &&
                        existingEnd.isBefore(newBookingEnd)) ||
                        (existingStart.isAfter(newBookingStart) &&
                                existingStart.isBefore(newBookingEnd.plusHours(2)))
                        ||
                        (newBookingStart.isAfter(existingStart) &&
                                newBookingStart.isBefore(existingEnd))
                        ||
                        (newBookingEnd.isAfter(existingStart) &&
                                newBookingEnd.isBefore(existingEnd))) {
                    throw new BusinessException(
                            "Cannot assign this job. The tasker needs at least 2 hours between jobs.");
                }
            } catch (BusinessException be) {
                throw be;
            } catch (Exception e) {
                log.warn("Failed to check scheduling for existing booking {}: {}",
                        existingBooking.getId(), e.getMessage());
                // Skip this booking if there's an issue
            }
        }

        if (tasker.getAvailabilityStatus().name().equals("available")) {
            booking.setTasker(tasker);
            booking.setBookingStatus(BookingStatus.assigned);
            taskerRepository.save(tasker);
            bookingRepository.save(booking);

            // Update tasker exposure stats
            updateTaskerExposureStats(taskerId);

            notificationService.notifyJobAccepted(bookingId, taskerId);
        }
    }

    private void updateTaskerExposureStats(long taskerId) {
        TaskerExposureStats stats = taskerExposureStatsRepository
                .findByTaskerId(taskerId)
                .orElseGet(() -> TaskerExposureStats.builder()
                        .taskerId(taskerId)
                        .notificationCount(0L)
                        .assignedJobCount(0L)
                        .build());

        stats.setAssignedJobCount(stats.getAssignedJobCount() + 1);
        stats.setLastJobDate(LocalDateTime.now());
        taskerExposureStatsRepository.save(stats);
    }

    // =================== GET BOOKING - GET TASK METHODS ===================
    @Override
    public PageResponse<?> getBookingDetail(int pageNo, int pageSize, Integer userId) {
        // Fetch all bookings for the user
        List<Bookings> allBookings = bookingRepository.findAllBookingsByUserId(userId);

        LocalDateTime now = LocalDateTime.now();

        // 1. Status priority: pending → assigned → completed → cancelled
        // 2. Date proximity: for active bookings, upcoming dates first (nearest first)
        // 3. For past dates or completed/cancelled bookings, newest first
        List<Bookings> sortedBookings = allBookings.stream()
                .sorted((b1, b2) -> {
                    int status1Priority = getStatusPriority(b1.getBookingStatus());
                    int status2Priority = getStatusPriority(b2.getBookingStatus());
                    if (status1Priority != status2Priority) {
                        return status1Priority - status2Priority;
                    }

                    // If statuses are equal, sort by date logic
                    LocalDateTime date1 = b1.getScheduledStart();
                    LocalDateTime date2 = b2.getScheduledStart();

                    if (date1 == null)
                        date1 = LocalDateTime.MAX;
                    if (date2 == null)
                        date2 = LocalDateTime.MAX;

                    boolean date1IsFuture = date1.isAfter(now);
                    boolean date2IsFuture = date2.isAfter(now);

                    if (status1Priority <= 1) {
                        if (date1IsFuture && !date2IsFuture) {
                            return -1;
                        } else if (!date1IsFuture && date2IsFuture) {
                            return 1;
                        }

                        if (date1IsFuture) {
                            return date1.compareTo(date2);
                        } else {
                            return date2.compareTo(date1);
                        }
                    }
                    // For completed/cancelled bookings, show most recent first
                    else {
                        // Sort by completion/cancellation date (using updated_at)
                        return b2.getUpdatedAt().compareTo(b1.getUpdatedAt());
                    }
                })
                .collect(Collectors.toList());

        // Pagination
        int totalItems = sortedBookings.size();
        int start = Math.max(0, (pageNo - 1) * pageSize);
        int end = Math.min(start + pageSize, totalItems);

        if (start >= totalItems) {
            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .totalPage((int) Math.ceil((double) totalItems / pageSize))
                    .items(List.of())
                    .build();
        }

        List<Bookings> pagedBookings = sortedBookings.subList(start, end);
        List<BookingDetailResponse> bookingDetails = bookingDetailResponses(pagedBookings);

        return PageResponse.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .totalPage((int) Math.ceil((double) totalItems / pageSize))
                .items(bookingDetails)
                .build();

    }

    /**
     * Gets the sorting priority for each booking status.
     * Lower numbers are shown first in the list.
     * 
     * @param status The booking status
     * @return The priority value (0 = highest priority, 4 = lowest)
     */
    private int getStatusPriority(BookingStatus status) {
        switch (status) {
            case pending:
                return 0; // Pending
            case assigned:
                return 1; // Assigned
            case completed:
                return 2; // Completed
            case cancelled:
                return 3; // Cancelled
            default:
                return 4; // Any other status
        }
    }

    @Override
    public PageResponse<?> getAllBookings(
            int pageNo,
            int pageSize,
            String status,
            String selectedDate,
            String customerSearch,
            String taskerSearch,
            String sortField,
            String sortOrder) {

        try {
            final LocalDate filterDate;
            final BookingStatus bookingStatus;

            // Parse selectedDate if provided
            if (selectedDate != null && !selectedDate.isEmpty()) {
                try {
                    filterDate = LocalDate.parse(
                            selectedDate.trim(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                } catch (DateTimeParseException e) {
                    log.warn("Invalid date format: {}. Expected yyyy-MM-dd format.", selectedDate);
                    throw new IllegalArgumentException("Invalid date format. Please use yyyy-MM-dd format.");
                }
            } else {
                filterDate = null;
            }

            // Parse status if provided
            if (status != null && !status.isEmpty()) {
                try {
                    bookingStatus = BookingStatus.valueOf(status.toLowerCase());
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid booking status: {}", status);
                    throw new IllegalArgumentException("Invalid booking status: " + status);
                }
            } else {
                bookingStatus = null;
            }

            // Start with all bookings
            List<Bookings> bookings = bookingRepository.findAll();

            // Apply filters one by one
            if (filterDate != null) {
                bookings = bookings.stream()
                        .filter(b -> b.getScheduledStart() != null &&
                                b.getScheduledStart().toLocalDate().equals(filterDate))
                        .collect(Collectors.toList());
            }

            if (bookingStatus != null) {
                bookings = bookings.stream()
                        .filter(b -> b.getBookingStatus() == bookingStatus)
                        .collect(Collectors.toList());
            }

            if (customerSearch != null && !customerSearch.isEmpty()) {
                List<Bookings> customerBookings = bookingRepository.findBookingsByCustomerName(customerSearch);
                bookings = customerBookings;
                // bookings.stream()
                // .filter(customerBookings::contains)
                // .collect(Collectors.toList());
            }

            if (taskerSearch != null && !taskerSearch.isEmpty()) {
                List<Bookings> taskerBookings = bookingRepository.findBookingsByTaskerName(taskerSearch);
                bookings = taskerBookings;
                // bookings.stream()
                // .filter(taskerBookings::contains)
                // .collect(Collectors.toList());
            }

            // Apply sorting
            if (sortField != null && !sortField.isEmpty()) {
                boolean ascending = sortOrder == null || sortOrder.equalsIgnoreCase("asc");

                bookings = applySorting(bookings, sortField, ascending);
            } else {
                // Default sorting by scheduled start time
                bookings = bookings.stream()
                        .sorted(Comparator.comparing(
                                b -> b.getScheduledStart() != null ? b.getScheduledStart() : LocalDateTime.MAX))
                        .collect(Collectors.toList());
            }

            // Pagination
            int totalItems = bookings.size();
            int start = Math.max(0, (pageNo - 1) * pageSize);
            int end = Math.min(start + pageSize, totalItems);

            if (start >= totalItems) {
                return PageResponse.builder()
                        .pageNo(pageNo)
                        .pageSize(pageSize)
                        .totalPage((int) Math.ceil((double) totalItems / pageSize))
                        .items(List.of())
                        .build();
            }

            List<Bookings> pagedBookings = bookings.subList(start, end);
            List<BookingDetailResponse> bookingDetails = bookingDetailResponses(pagedBookings);

            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .totalPage((int) Math.ceil((double) totalItems / pageSize))
                    .items(bookingDetails)
                    .build();

        } catch (ResourceNotFoundException | IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error getting bookings: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve bookings: " + e.getMessage());
        }
    }

    /**
     * Apply sorting to a list of bookings based on field name and direction
     */
    private List<Bookings> applySorting(List<Bookings> bookings, String sortField, boolean ascending) {
        Comparator<Bookings> comparator;

        switch (sortField.toLowerCase()) {
            case "id":
                comparator = Comparator.comparing(Bookings::getId);
                break;
            case "status":
                comparator = Comparator.comparing(b -> b.getBookingStatus().name());
                break;
            case "price":
                comparator = Comparator.comparing(Bookings::getTotalPrice);
                break;
            case "created":
                comparator = Comparator.comparing(Bookings::getCreatedAt);
                break;
            case "customername":
                comparator = Comparator.comparing(b -> b.getUser() != null ? b.getUser().getFirstLastName() : "");
                break;
            case "taskername":
                comparator = Comparator.comparing(b -> b.getTasker() != null ? b.getTasker().getFirstLastName() : "");
                break;
            case "date":
            default:
                comparator = Comparator.comparing(
                        b -> b.getScheduledStart() != null ? b.getScheduledStart() : LocalDateTime.MAX);
                break;
        }

        if (!ascending) {
            comparator = comparator.reversed();
        }

        return bookings.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    @Override
    public PageResponse<?> getBookingFilteringStatus(int pageNo, int pageSize, Integer userId, String status) {
        try {
            // Convert the status string to BookingStatus enum
            BookingStatus bookingStatus = BookingStatus.valueOf(status.toLowerCase());

            // Fetch bookings for the user with the specified status
            List<Bookings> filteredBookings = bookingRepository.findBookingsByUserIdAndStatus(userId, bookingStatus);

            // Apply sorting logic for dates
            LocalDateTime now = LocalDateTime.now();

            // Sort by date proximity - for future dates, nearest first; for past dates,
            // most recent first
            List<Bookings> sortedBookings = filteredBookings.stream()
                    .sorted((b1, b2) -> {
                        // Get scheduled dates
                        LocalDateTime date1 = b1.getScheduledStart();
                        LocalDateTime date2 = b2.getScheduledStart();

                        if (date1 == null)
                            date1 = LocalDateTime.MAX;
                        if (date2 == null)
                            date2 = LocalDateTime.MAX;

                        boolean date1IsFuture = date1.isAfter(now);
                        boolean date2IsFuture = date2.isAfter(now);

                        // Future dates before past dates
                        if (date1IsFuture && !date2IsFuture) {
                            return -1;
                        } else if (!date1IsFuture && date2IsFuture) {
                            return 1;
                        }

                        // Both dates in future or both in past, sort by proximity to now
                        if (date1IsFuture) {
                            // Both in future, nearest first
                            return date1.compareTo(date2);
                        } else {
                            // Both in past, newest first
                            return date2.compareTo(date1);
                        }
                    })
                    .collect(Collectors.toList());

            int totalItems = sortedBookings.size();
            int start = Math.max(0, (pageNo - 1) * pageSize);
            int end = Math.min(start + pageSize, totalItems);

            if (start >= totalItems) {
                return PageResponse.builder()
                        .pageNo(pageNo)
                        .pageSize(pageSize)
                        .totalPage((int) Math.ceil((double) totalItems / pageSize))
                        .items(List.of())
                        .build();
            }

            List<Bookings> pagedBookings = sortedBookings.subList(start, end);
            List<BookingDetailResponse> bookingDetails = bookingDetailResponses(pagedBookings);

            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .totalPage((int) Math.ceil((double) totalItems / pageSize))
                    .items(bookingDetails)
                    .build();

        } catch (IllegalArgumentException e) {
            // Handle invalid status parameter
            throw new IllegalArgumentException("Invalid booking status: " + status);
        }
    }

    @Override
    public PageResponse<?> getTaskForTasker(int pageNo, int pageSize, Long taskerId, List<Long> serviceIds) {
        try {
            List<Bookings> bookingWithService = bookingRepository.getTaskForTasker(serviceIds);
            LocalDateTime now = LocalDateTime.now();

            List<Bookings> availableTasks;

            if (taskerId != null) {
                List<Long> notifiedBookingIds = taskerNotificationRepository.findNotifiedBookingIdsByTaskerId(taskerId);

                availableTasks = bookingWithService.stream()
                        .filter(booking -> notifiedBookingIds.contains(booking.getId()))
                        .collect(Collectors.toList());

                log.info("Tasker {} has been notified about {} tasks", taskerId, availableTasks.size());
            } else {
                throw new ResourceNotFoundException("Tasker not found!");
            }

            // Filter for future bookings and sort by scheduled start
            List<Bookings> futureBookings = availableTasks.stream()
                    .filter(booking -> {
                        LocalDateTime scheduledStart = booking.getScheduledStart();
                        return scheduledStart != null && (scheduledStart.isAfter(now) || scheduledStart.isEqual(now));
                    })
                    .sorted((b1, b2) -> {
                        LocalDateTime date1 = b1.getScheduledStart();
                        LocalDateTime date2 = b2.getScheduledStart();

                        if (date1 == null)
                            return 1;
                        if (date2 == null)
                            return -1;

                        return date1.compareTo(date2);
                    })
                    .collect(Collectors.toList());

            int start = pageNo > 0 ? (pageNo - 1) * pageSize : 0;
            int end = Math.min(start + pageSize, futureBookings.size());

            if (start >= futureBookings.size()) {
                return PageResponse.builder()
                        .pageNo(pageNo)
                        .pageSize(pageSize)
                        .items(List.of())
                        .build();
            }

            List<Bookings> pagedBookings = futureBookings.subList(start, end);

            List<BookingDetailResponse> bookingDetails = bookingDetailResponses(pagedBookings);

            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .items(bookingDetails)
                    .build();

        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid request: " + e.getMessage());
        }
    }

    /*
     * Gets all assigned bookings for the specific tasker based on specified date
     */
    @Override
    public PageResponse<?> getTaskAssignByTaskerFollowDateTime(int pageNo, int pageSize, Long taskerId,
            String selectedDate) {

        try {
            LocalDate filterDate = null;

            // Parse selectedDate
            if (selectedDate != null && !selectedDate.isEmpty()) {
                try {
                    filterDate = LocalDate.parse(
                            selectedDate.trim(), DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                } catch (DateTimeParseException e) {
                    log.warn("Invalid date format: {}. Expected dd/MM/yyyy format.", selectedDate);
                    throw new IllegalArgumentException("Invalid date format. Please use dd/MM/yyyy format.");
                }
            }

            // Get filtered bookings directly from database
            List<Bookings> filteredBookings;
            if (filterDate != null) {
                filteredBookings = bookingRepository.getTaskAssignByTaskerFollowDate(taskerId, filterDate);
            } else {
                filteredBookings = bookingRepository.getTaskAssignByTasker(taskerId)
                        .stream()
                        .sorted(Comparator.comparing(
                                booking -> booking.getScheduledStart() != null ? booking.getScheduledStart()
                                        : LocalDateTime.MAX))
                        .collect(Collectors.toList());
            }

            // Pagination
            int totalItems = filteredBookings.size();
            int start = Math.max(0, (pageNo - 1) * pageSize);
            int end = Math.min(start + pageSize, totalItems);

            if (start >= totalItems) {
                return PageResponse.builder()
                        .pageNo(pageNo)
                        .pageSize(pageSize)
                        .totalPage((int) Math.ceil((double) totalItems / pageSize))
                        .items(List.of())
                        .build();
            }

            List<Bookings> pagedBookings = filteredBookings.subList(start, end);
            List<BookingDetailResponse> bookingDetails = bookingDetailResponses(pagedBookings);

            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .totalPage((int) Math.ceil((double) totalItems / pageSize))
                    .items(bookingDetails)
                    .build();

        } catch (ResourceNotFoundException | IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error getting tasks for tasker: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve tasks: " + e.getMessage());
        }
    }

    @Override
    public PageResponse<?> getHistoryTask(int pageNo, int pageSize, Integer taskerId) {
        List<Bookings> getHistoryTask = bookingRepository.findHistoryTask(taskerId);

        int totalItems = getHistoryTask.size();
        int start = Math.max(0, (pageNo - 1) * pageSize);
        int end = Math.min(start + pageSize, totalItems);

        if (start >= totalItems) {
            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .totalPage((int) Math.ceil((double) totalItems / pageSize))
                    .items(List.of())
                    .build();
        }

        List<Bookings> pagedBookings = getHistoryTask.subList(start, end);
        List<BookingDetailResponse> bookingDetails = bookingDetailResponses(pagedBookings);

        return PageResponse.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .totalPage((int) Math.ceil((double) totalItems / pageSize))
                .items(bookingDetails)
                .build();
    }

    public List<BookingDetailResponse> bookingDetailResponses(List<Bookings> pagedBookings) {
        return pagedBookings.stream()
                .map(booking -> {
                    BookingDetailResponse response = BookingDetailResponse.builder()
                            .bookingId(booking.getId())
                            .serviceId(booking.getService().getId())
                            .userId(booking.getUser().getId())
                            .username(booking.getUser().getFirstLastName())
                            .phoneNumber(booking.getUser().getPhoneNumber())
                            .serviceName(booking.getService().getName())
                            .scheduledStart(booking.getScheduledStart())
                            .scheduledEnd(booking.getScheduledEnd())
                            .duration(booking.getDurationMinutes())
                            .taskDetails(booking.getTaskDetails())
                            .totalPrice(booking.getTotalPrice())
                            .address(booking.getAddress())
                            .cancelBy(booking.getCancelledByType().name())
                            .cancelReason(booking.getCancellationReason())
                            .status(booking.getBookingStatus().name())
                            .paymentStatus(booking.getPaymentStatus())
                            .latitude(booking.getLatitude())
                            .longitude(booking.getLongitude())
                            .completedAt(booking.getCompletedAt())
                            .notes(booking.getNotes())
                            .build();

                    if (booking.getTasker() != null) {
                        response.setTaskerId(booking.getTasker().getId());
                        response.setTaskerName(booking.getTasker().getFirstLastName());
                        response.setTaskerPhone(booking.getTasker().getPhoneNumber());
                        response.setTaskerImage(booking.getTasker().getProfileImage());
                    }
                    return response;
                })
                .collect(Collectors.toList());
    }

    // =================== CANCEL TASK - CANCEL BOOKING METHODS ===================
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

        Integer taskerId = booking.getTasker().getId();

        Tasker tasker = taskerRepository.findById(taskerId.longValue())
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

        // Check cancellations in the last 7 days
        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        int cancelCount = bookingRepository.countCancelledBookingsByTaskerInLast7Days(tasker.getId().longValue(),
                sevenDaysAgo);

        if (cancelCount >= 2) {
            throw new BusinessException(
                    "You have exceeded the limit of 2 cancellations in 7 days. This job cannot be canceled.");
        }

        if (cancelCount == 1) {
            log.warn("Tasker [{}] is canceling its 2nd job in 7 days. This is the last cancellation allowed.",
                    taskerId);
        }

        taskerWalletService.fineTaskerCancelJob(tasker.getId().longValue(), bookingId, cancelReason);

        booking.setBookingStatus(BookingStatus.cancelled);
        booking.setCancelledByType(CancelledByType.tasker);
        booking.setCancellationReason(cancelReason);
        booking.setUpdatedAt(LocalDateTime.now());
        bookingRepository.save(booking);
        taskerRepository.save(tasker);

        notificationService.notifyJobCancelled(bookingId, cancelReason, booking.getCancelledByType().name());

    }

    // =================== COMPLETED JOB METHODS ===================
    @Override
    public void completedJob(long bookingId) {
        Bookings booking = getBookingById(bookingId);

        Long taskerId = booking.getTasker().getId().longValue();

        Tasker tasker = taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id: " + taskerId));

        Payments payment = paymentRepository.findPaymentByBookingId(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with bookingId: " + bookingId));

        if (booking.getPaymentStatus().equalsIgnoreCase("unpaid")) {
            payment.setStatus(PaymentStatus.completed);
            paymentRepository.save(payment);

            booking.setPaymentStatus("paid");
        }
        booking.setCompletedAt(LocalDateTime.now());
        booking.setBookingStatus(BookingStatus.completed);
        bookingRepository.save(booking);

        tasker.setAvailabilityStatus(AvailabilityStatus.available);
        taskerRepository.save(tasker);

        taskerWalletService.incomeCompleteTask(booking.getId(), taskerId);

        notificationService.notifyJobCompleted(bookingId, taskerId);
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
