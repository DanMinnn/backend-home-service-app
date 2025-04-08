package com.danmin.home_service.model;

import java.util.Date;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_unavailable_dates")
public class TaskerUnavailableDate extends AbstractEntity<Long> {

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @Column(name = "start_date", nullable = false)
    private Date startDate;

    @Column(name = "end_date", nullable = false)
    private Date endDate;

    @Column(name = "reason")
    private String reason;
}
