package com.danmin.home_service.dto.response.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TopServiceResponse {
    private Long serviceId;
    private String serviceName;
    private String categoryName;
    private Long bookingCount;
}
