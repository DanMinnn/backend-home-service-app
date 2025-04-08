package com.danmin.home_service.model;

import java.math.BigDecimal;

import com.danmin.home_service.common.PriceUnitType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "services")
public class Service extends AbstractEntity<Long> {

    @ManyToOne
    @JoinColumn(name = "category_id")
    private ServiceCategory category;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "base_price", nullable = false)
    private BigDecimal basePrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "price_unit", nullable = false)
    private PriceUnitType priceUnit;

    @Column(name = "estimated_duration", nullable = false)
    private Integer estimatedDuration;

    @Column(name = "icon")
    private String icon;

    @Column(name = "is_active")
    private Boolean isActive = true;
}
