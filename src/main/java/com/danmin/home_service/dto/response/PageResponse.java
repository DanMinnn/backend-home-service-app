package com.danmin.home_service.dto.response;

import java.io.Serializable;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class PageResponse<T> implements Serializable {

    private int pageNo;
    private int pageSize;
    private int totalPage;
    private T items;
}
