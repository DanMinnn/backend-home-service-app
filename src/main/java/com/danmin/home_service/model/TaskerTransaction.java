package com.danmin.home_service.model;

import java.math.BigDecimal;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.TransactionStatus;
import com.danmin.home_service.common.TransactionType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_transaction")
public class TaskerTransaction extends AbstractEntityCreatedAt<Integer> {

    @ManyToOne
    @JoinColumn(name = "tasker_id", nullable = false)
    private Tasker tasker;

    @Column(precision = 10, scale = 2)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "type")
    private TransactionType transactionType;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status")
    private TransactionStatus transactionStatus;

    @Column(name = "description")
    private String description;

}
