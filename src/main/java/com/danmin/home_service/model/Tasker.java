package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.AvailabilityStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker")
public class Tasker extends AbstractEntity<Long> {

    @Column(name = "earth_location", columnDefinition = "earth")
    private String earthLocation;

    @Column(name = "latitude")
    private BigDecimal latitude;

    @Column(name = "longitude")
    private BigDecimal longitude;

    @Column(name = "average_rating")
    private Double average_rating;

    @Column(name = "total_earnings")
    private Double total_earnings;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "availability_status")
    private AvailabilityStatus availabilityStatus;

    @OneToOne(mappedBy = "tasker", fetch = FetchType.LAZY)
    private Account account;

    @OneToMany(mappedBy = "tasker", fetch = FetchType.LAZY)
    private Set<UserVerifications> userVerifications = new HashSet<>();

}
