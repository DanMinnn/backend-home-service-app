package com.danmin.home_service.model;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_reputation")
public class TaskerReputation extends AbstractEntityNoDate<Integer> {

    @Column(name = "tasker_id")
    private Integer taskerId;
    @Column(name = "reputation_score")
    private BigDecimal reputationScore;

}
