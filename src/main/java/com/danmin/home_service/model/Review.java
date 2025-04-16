package com.danmin.home_service.model;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.ReviewerType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "reviews")
public class Review extends AbstractEntity<Long> {

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private Bookings booking;

    @Column(name = "reviewer_id", nullable = false)
    private Integer reviewerId;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "reviewer_type", nullable = false)
    private ReviewerType reviewerType;

    @Column(name = "rating", nullable = false)
    private Integer rating;

    @Column(name = "comment", columnDefinition = "TEXT")
    private String comment;
}
