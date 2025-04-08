package com.danmin.home_service.model;

import java.math.BigDecimal;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_services", uniqueConstraints = { @UniqueConstraint(columnNames = { "tasker_id, service_id" }) })
public class TaskerService extends AbstractEntityNoDate<Integer> {

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Service service;

    @Column(name = "price_adjustment")
    private BigDecimal priceAdjustment = BigDecimal.ZERO;

    @Column(name = "experience_years")
    private BigDecimal experienceYears = BigDecimal.ZERO;

    @Column(name = "is_verified")
    private Boolean isVerified = false;

}
