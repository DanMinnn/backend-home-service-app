package com.danmin.home_service.dto.response.dashboard;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRegistrationResponse {
    private Long totalClients;
    private Long totalTaskers;
    private Long newUsersToday;
    private Long newUsersThisWeek;
    private Long newUsersThisMonth;

    public UserRegistrationResponse(Long totalClients, Long totalTaskers, Long newUsersToday,
            Long newUsersThisWeek, Long newUsersThisMonth) {
        this.totalClients = totalClients;
        this.totalTaskers = totalTaskers;
        this.newUsersToday = newUsersToday;
        this.newUsersThisWeek = newUsersThisWeek;
        this.newUsersThisMonth = newUsersThisMonth;
    }

}
