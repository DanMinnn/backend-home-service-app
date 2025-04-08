package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.Date;

import com.danmin.home_service.common.PaymentStatus;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "payments")
public class Payments extends AbstractEntityNoDate<Integer> {

    @ManyToOne
    @JoinColumn(name = "booking_id", nullable = false)
    private Bookings booking;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "tasker_id", nullable = false)
    private Tasker tasker;

    @ManyToOne
    @JoinColumn(name = "payment_method_id", nullable = false)
    private PaymentMethods paymentMethod;

    @Column(name = "amount", nullable = false)
    private BigDecimal amount;

    @Column(name = "currency", length = 3)
    private String currency;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private PaymentStatus status;

    @Column(name = "transaction_id")
    private String transactionId;

    @Column(name = "payment_date")
    private Date paymentDate;

    @Column(name = "refund_amount")
    private BigDecimal refundAmount = BigDecimal.ZERO;

    @Column(name = "refund_reason", columnDefinition = "TEXT")
    private String refundReason;

    @Column(name = "refund_date")
    private Date refundDate;

    @Column(name = "payment_gateway", nullable = false)
    private String paymentGateway;

    @Column(name = "gateway_response", columnDefinition = "TEXT")
    private String gatewayResponse;

    @Column(name = "receipt_url")
    private String receiptUrl;

}
