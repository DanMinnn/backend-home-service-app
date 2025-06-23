package com.danmin.home_service.service;

import java.util.List;

import com.danmin.home_service.dto.request.AddressDTO;
import com.danmin.home_service.dto.request.TaskerServiceDTO;
import com.danmin.home_service.dto.request.UserDTO;
import com.danmin.home_service.dto.response.TaskerResponse;
import com.danmin.home_service.dto.response.TaskerServiceResponse;

public interface TaskerService {
    void updateProfileUser(long taskerId, UserDTO user);

    void deleteAccount(long userId);

    void saveAddress(long userId, AddressDTO address);

    TaskerResponse getProfileTasker(String email);

    void addTaskerService(TaskerServiceDTO taskerServiceDTO);

    List<TaskerServiceResponse> getTaskerService(Integer taskerId);
}
