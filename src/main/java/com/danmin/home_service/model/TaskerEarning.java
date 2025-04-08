package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.Date;

import com.danmin.home_service.common.EarningStatus;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_earnings")
public class TaskerEarning extends AbstractEntityCreatedAt<Long> {

    @ManyToOne
    @JoinColumn(name = "tasker_id", nullable = false)
    private Tasker tasker;

    @OneToOne
    @JoinColumn(name = "booking_id", nullable = false)
    private Bookings booking;

    @Column(name = "amount", nullable = false)
    private BigDecimal amount;

    @Column(name = "platform_fee", nullable = false)
    private BigDecimal platformFee;

    @Column(name = "net_amount", nullable = false)
    private BigDecimal netAmount;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private EarningStatus status;

    @Column(name = "paid_at")
    private Date paidAt;

}
