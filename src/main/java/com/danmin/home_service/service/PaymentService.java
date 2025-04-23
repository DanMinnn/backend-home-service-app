package com.danmin.home_service.service;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;

import com.danmin.home_service.common.MethodType;
import com.danmin.home_service.common.PaymentStatus;
import com.danmin.home_service.config.VnPayConfig;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.Payments;
import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.PaymentRepository;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j(topic = "PAYMENT-SERVICE")
public class PaymentService {

    private final VnPayConfig vnPayConfig;
    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;

    public String createPaymentUrl(HttpServletRequest request, Long bookingId) throws UnsupportedEncodingException {

        Bookings booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found !"));

        // get current date
        String vnpCreateDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

        String orderId = String.valueOf(System.currentTimeMillis());

        // get client IP
        String vnpIpAddr = getClientIp(request);

        // build the parameters
        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", vnPayConfig.getVnpVersion());
        vnpParams.put("vnp_Command", "pay");
        vnpParams.put("vnp_TmnCode", vnPayConfig.getVnpTmnCode());
        vnpParams.put("vnp_Amount", String.valueOf(booking.getTotalPrice().intValue() * 100000));
        vnpParams.put("vnp_CurrCode", "VND");
        vnpParams.put("vnp_BankCode", "NCB");
        vnpParams.put("vnp_TxnRef", orderId);
        vnpParams.put("vnp_OrderInfo", "Thanh toan dich vu bTaskee, Booking ID: " + bookingId);
        vnpParams.put("vnp_OrderType", "other");
        vnpParams.put("vnp_Locale", "vn");
        vnpParams.put("vnp_ReturnUrl", vnPayConfig.getVnpReturnUrl() + "?bookingId=" + bookingId);
        vnpParams.put("vnp_IpAddr", vnpIpAddr);
        vnpParams.put("vnp_CreateDate", vnpCreateDate);

        // Build hash data and query
        List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnpParams.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                // Build hash data
                hashData.append(fieldName).append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));

                // Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()))
                        .append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));

                if (itr.hasNext()) {
                    hashData.append('&');
                    query.append('&');
                }
            }
        }

        // Create the HMAC hash value
        String vnpSecureHash = hmacSHA512(vnPayConfig.getVnpHashSecret(), hashData.toString());
        query.append("&vnp_SecureHash=").append(vnpSecureHash);

        // Create payment record
        createPendingPayment(booking, orderId);

        return vnPayConfig.getVnpPayUrl() + "?" + query;
    }

    private void createPendingPayment(Bookings booking, String transactionId) {

        paymentRepository.save(Payments.builder()
                .booking(booking)
                .user(booking.getUser())
                .tasker(booking.getTasker())
                .amount(booking.getTotalPrice())
                .currency("VND")
                .methodType(MethodType.vnpay)
                .status(PaymentStatus.pending)
                .transactionId(transactionId)
                .paymentGateway(MethodType.vnpay.toString()).build());
    }

    public void updatePaymentStatus(String transactionId, String responseCode, Long bookingId) {
        Payments payment = paymentRepository.findByTransactionId(transactionId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));

        if ("00".equals(responseCode)) {
            payment.setStatus(PaymentStatus.completed);
            payment.setPaymentDate(new Date());
        } else {
            payment.setStatus(PaymentStatus.failed);
        }

        paymentRepository.save(payment);

        // Update booking status if payment is successful
        // if ("00".equals(responseCode)) {
        // Bookings booking = bookingRepository.findById(bookingId)
        // .orElseThrow(() -> new RuntimeException("Booking not found"));
        // // Update booking status as needed
        // // booking.setStatus(...);
        // bookingRepository.save(booking);
        // }
    }

    // Hash all fields for VNPAY
    public String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                sb.append(fieldName);
                sb.append("=");
                sb.append(fieldValue);
            }
            if (itr.hasNext()) {
                sb.append("&");
            }
        }
        return hmacSHA512(vnPayConfig.getVnpHashSecret(), sb.toString());
    }

    // HMAC-SHA512 function
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    private String getClientIp(HttpServletRequest request) {
        String ipAddress;
        ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }

}
