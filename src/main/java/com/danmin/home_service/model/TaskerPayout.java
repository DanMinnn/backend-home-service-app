package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.Date;

import com.danmin.home_service.common.PayoutStatus;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_payouts")
public class TaskerPayout extends AbstractEntityNoDate<Integer> {

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @Column(name = "amount", nullable = false)
    private BigDecimal amount;

    @Column(name = "payout_method", nullable = false)
    private String payoutMethod;

    @Column(name = "account_details", nullable = false)
    private String accountDetails;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private PayoutStatus payoutStatus;

    @Column(name = "transaction_id")
    private String transactionId;

    @Column(name = "request_date")
    private Date requestDate;

    @Column(name = "process_date")
    private Date processDate;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
}
