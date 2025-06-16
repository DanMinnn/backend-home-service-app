package com.danmin.home_service.dto.response;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;

@Getter
public class TaskerReviewResponse implements Serializable {

    Integer taskerId;
    BigDecimal reputationScore;
    Long totalReviews;

    public TaskerReviewResponse(Integer taskerId, BigDecimal reputationScore, Long totalReviews) {
        this.taskerId = taskerId;
        this.reputationScore = reputationScore;
        this.totalReviews = totalReviews;
    }

}
