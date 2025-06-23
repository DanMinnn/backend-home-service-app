package com.danmin.home_service.service.impl;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.danmin.home_service.dto.request.AddressDTO;
import com.danmin.home_service.dto.request.TaskerServiceDTO;
import com.danmin.home_service.dto.request.UserDTO;
import com.danmin.home_service.dto.response.ServiceResponse;
import com.danmin.home_service.dto.response.TaskerResponse;
import com.danmin.home_service.dto.response.TaskerServiceResponse;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.TaskerServiceModel;
import com.danmin.home_service.repository.ServiceRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.TaskerServiceRepository;
import com.danmin.home_service.service.TaskerService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TaskerServiceImpl implements TaskerService {

    private final TaskerRepository taskerRepository;
    private final ServiceRepository serviceRepository;
    private final TaskerServiceRepository taskerServiceRepository;

    Tasker getTaskerById(Long taskerId) {
        return taskerRepository.findById(taskerId)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with id"));
    }

    @Override
    public void updateProfileUser(long taskerId, UserDTO user) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'updateProfileUser'");
    }

    @Override
    public void deleteAccount(long userId) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'deleteAccount'");
    }

    @Override
    public void saveAddress(long userId, AddressDTO address) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'saveAddress'");
    }

    @Transactional
    @Override
    public TaskerResponse getProfileTasker(String email) {

        Tasker tasker = taskerRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found with email"));

        Set<ServiceResponse> services = tasker.getTaskerServices().stream()
                .map(service -> ServiceResponse.builder()
                        .id(service.getService().getId())
                        .name(service.getService().getName())
                        .description(service.getService().getDescription())
                        .icon(service.getService().getIcon())
                        .isActive(service.getService().getIsActive())
                        .build())
                .collect(Collectors.toCollection(LinkedHashSet::new));

        return TaskerResponse.builder().id(tasker.getId()).email(tasker.getEmail()).fullName(tasker.getFirstLastName())
                .profileImage(tasker.getProfileImage())
                .phoneNumber(tasker.getPhoneNumber())
                .isActive(tasker.getIsActive())
                .lastLogin(tasker.getLastLogin())
                .services(services).build();
    }

    /*  */
    @Override
    public void addTaskerService(TaskerServiceDTO taskerServiceDTO) {
        Tasker tasker = getTaskerById(taskerServiceDTO.getTaskerId());

        // when tasker register, they can choose service apply for job
        if (taskerServiceDTO.getServiceIds() != null &&
                !taskerServiceDTO.getServiceIds().isEmpty()) {
            for (Long serviceId : taskerServiceDTO.getServiceIds()) {
                Services services = serviceRepository.findById(serviceId).orElseThrow(
                        () -> new ResourceNotFoundException("Service not found with id: " +
                                serviceId));

                taskerServiceRepository.save(TaskerServiceModel.builder()
                        .tasker(tasker)
                        .service(services)
                        .taskerName(tasker.getFirstLastName())
                        .serviceName(services.getName())
                        .isVerified(true).build());
            }
        }

    }

    @Override
    @Transactional
    public List<TaskerServiceResponse> getTaskerService(Integer taskerId) {
        return taskerServiceRepository.getServicesOfTasker(taskerId);

    }
}
