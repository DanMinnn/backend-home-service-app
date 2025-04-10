package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.locationtech.jts.geom.Point;

import com.danmin.home_service.common.AvailabilityStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@SuperBuilder
@Entity
@Table(name = "tasker", uniqueConstraints = { @UniqueConstraint(columnNames = "email, phone_number") })
public class Tasker extends AbstractUser<Integer> {

    @Column(name = "earth_location", columnDefinition = "geometry(Point,4326)")
    private Point earthLocation;

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

    @OneToMany(mappedBy = "tasker", fetch = FetchType.LAZY)
    private Set<UserVerifications> userVerifications = new HashSet<>();

}
