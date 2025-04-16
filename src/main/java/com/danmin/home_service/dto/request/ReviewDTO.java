package com.danmin.home_service.dto.request;

import java.io.Serializable;
import lombok.Getter;

@Getter
public class ReviewDTO implements Serializable {

    private Long bookingId;
    private Integer reviewerId;
    private Integer rating;
    private String comment;
}
