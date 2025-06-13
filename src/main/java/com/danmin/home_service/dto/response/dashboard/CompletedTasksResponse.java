package com.danmin.home_service.dto.response.dashboard;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CompletedTasksResponse {
    private Long totalCompletedTasks;
    private Long completedTasksToday;
    private Long completedTasksThisWeek;
    private Long completedTasksThisMonth;

    public CompletedTasksResponse(Long totalCompletedTasks, Long completedTasksToday, Long completedTasksThisWeek,
            Long completedTasksThisMonth) {
        this.totalCompletedTasks = totalCompletedTasks;
        this.completedTasksToday = completedTasksToday;
        this.completedTasksThisWeek = completedTasksThisWeek;
        this.completedTasksThisMonth = completedTasksThisMonth;
    }

}
