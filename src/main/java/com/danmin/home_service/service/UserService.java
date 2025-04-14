package com.danmin.home_service.service;

import com.danmin.home_service.dto.request.UserDTO;
import com.danmin.home_service.dto.response.PageResponse;

public interface UserService {

    void updateProfileUser(long userId, UserDTO user);

    void deleteAccount(long userId);

    PageResponse<?> getAllUser(int pageNo, int pageSize);

    PageResponse<?> getAllTasker(int pageNo, int pageSize);

    PageResponse<?> getAllUserWithSortByColumnsAndSearch(int pageNo, int pageSize, String search, String sortBy);

    PageResponse<?> getAllTaskerWithSortByColumnsAndSearch(int pageNo, int pageSize, String search, String sortBy);
}
