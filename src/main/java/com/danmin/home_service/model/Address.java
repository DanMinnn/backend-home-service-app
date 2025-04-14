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
@Table(name = "user_addresses")
public class Address extends AbstractEntity<Long> {

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "address_name", nullable = false)
    private String addressName;

    @Column(name = "apartment_type", nullable = false)
    private String apartmentType;

    @Column(name = "houser_number", nullable = false)
    private String houserNumber;

    @Column(name = "latitude")
    private BigDecimal latitude;

    @Column(name = "longitude")
    private BigDecimal longitude;

    @Column(name = "is_default")
    private Boolean isDefault = false;

}
