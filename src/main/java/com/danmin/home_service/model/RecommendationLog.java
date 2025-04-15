package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.Date;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "recommendation_logs")
public class RecommendationLog extends AbstractEntityNoDate<Integer> {
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Services service;

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @Column(name = "recommendation_type", nullable = false)
    private String recommendationType;

    @Column(name = "relevance_score")
    private BigDecimal relevanceScore;

    @Column(name = "shown_at")
    private Date shownAt;

    @Column(name = "was_clicked", columnDefinition = "BOOLEAN DEFAULT false")
    private Boolean wasClicked;

    @Column(name = "clicked_at")
    private Date clickedAt;

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private Bookings booking;

    @Column(name = "resulted_in_booking", columnDefinition = "BOOLEAN DEFAULT false")
    private Boolean resultedInBooking;
}
