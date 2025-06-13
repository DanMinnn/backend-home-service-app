package com.danmin.home_service.dto.response.dashboard;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TopTaskerResponse {
    private Integer taskerId;
    private String taskerName;
    private String profileImage;
    private BigDecimal reputationScore;
    private Long completedTasksCount;

    public TopTaskerResponse(Integer taskerId, String taskerName, String profileImage, BigDecimal reputationScore,
            Long completedTasksCount) {
        this.taskerId = taskerId;
        this.taskerName = taskerName;
        this.profileImage = profileImage;
        this.reputationScore = reputationScore;
        this.completedTasksCount = completedTasksCount;
    }

}
