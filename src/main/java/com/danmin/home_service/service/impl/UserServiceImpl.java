package com.danmin.home_service.service.impl;

import java.util.List;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.request.AddressDTO;
import com.danmin.home_service.dto.request.UserDTO;
import com.danmin.home_service.dto.response.PageResponse;
import com.danmin.home_service.dto.response.UserResponse;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Address;
import com.danmin.home_service.model.BaseUser;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.AddressRepository;
import com.danmin.home_service.repository.SearchRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.UserService;
import com.danmin.home_service.service.UserTypeService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserTypeService userTypeService;
    private final UserRepository userRepository;
    private final TaskerRepository taskerRepository;
    private final SearchRepository searchRepository;
    private final AddressRepository addressRepository;

    @Override
    public void updateProfileUser(long userId, UserDTO req) {
        var user = getUserById(userId);

        if (user instanceof User) {
            User userUpdate = (User) user;

            if (req.getFirstLastName() != null) {
                userUpdate.setFirstLastName(req.getFirstLastName());
            }

            if (req.getProfileImage() != null) {
                userUpdate.setProfileImage(req.getProfileImage());
            }

            if (req.getAddress() != null) {
                userUpdate.setAddress(req.getAddress());
            }

            userRepository.save(userUpdate);
        } else if (user instanceof Tasker) {
            Tasker tasker = (Tasker) user;

            if (req.getFirstLastName() != null) {
                tasker.setFirstLastName(req.getFirstLastName());
            }

            if (req.getProfileImage() != null) {
                tasker.setProfileImage(req.getProfileImage());
            }

            if (req.getAddress() != null) {
                tasker.setAddress(req.getAddress());
            }

            taskerRepository.save(tasker);
        }
    }

    @Override
    public void deleteAccount(long userId) {
        var account = getUserById(userId);

        if (account instanceof User) {
            User user = (User) account;
            user.setIsActive(false);
            userRepository.save(user);

        } else if (account instanceof Tasker) {
            Tasker tasker = (Tasker) account;
            tasker.setIsActive(false);
            taskerRepository.save(tasker);
        }

    }

    private BaseUser getUserById(long userId) {

        return userTypeService.findById(userId).orElseThrow(() -> new AccessDeniedException("User not found"));

    }

    @Override
    public PageResponse<?> getAllUser(int pageNo, int pageSize) {
        List<User> users = userRepository.findAll();

        int totalItems = users.size();
        int start = Math.max(0, (pageNo - 1) * pageSize);
        int end = Math.min(start + pageSize, totalItems);

        if (start >= totalItems) {
            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .totalPage((int) Math.ceil((double) totalItems / pageSize))
                    .items(List.of())
                    .build();
        }

        List<User> pagedUsers = users.subList(start, end);

        List<UserResponse> responses = pagedUsers.stream().map(user -> UserResponse.builder()
                .id(user.getId())
                .firstLastName(user.getFirstLastName())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .profileImage(user.getProfileImage())
                .createAt(user.getCreatedAt())
                .isActive(user.getIsActive())
                .lastLogin(user.getLastLogin()).build()).toList();

        return PageResponse.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .items(responses)
                .build();
    }

    @Override
    public PageResponse<?> getAllTasker(int pageNo, int pageSize) {

        List<Tasker> taskers = taskerRepository.findAll();

        int totalItems = taskers.size();
        int start = Math.max(0, (pageNo - 1) * pageSize);
        int end = Math.min(start + pageSize, totalItems);

        if (start >= totalItems) {
            return PageResponse.builder()
                    .pageNo(pageNo)
                    .pageSize(pageSize)
                    .totalPage((int) Math.ceil((double) totalItems / pageSize))
                    .items(List.of())
                    .build();
        }

        List<Tasker> pagedTaskersList = taskers.subList(start, end);

        List<UserResponse> responses = pagedTaskersList.stream().map(tasker -> UserResponse.builder()
                .id(tasker.getId())
                .firstLastName(tasker.getFirstLastName())
                .email(tasker.getEmail())
                .phoneNumber(tasker.getPhoneNumber())
                .profileImage(tasker.getProfileImage())
                .taskerStatus(tasker.getAvailabilityStatus().name())
                .createAt(tasker.getCreatedAt())
                .isActive(tasker.getIsActive())
                .lastLogin(tasker.getLastLogin()).build()).toList();

        return PageResponse.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .totalPage((int) Math.ceil((double) totalItems / pageSize))
                .items(responses)
                .build();
    }

    @Override
    public PageResponse<?> getAllUserWithSortByColumnsAndSearch(int pageNo, int pageSize, String search,
            String sortBy) {
        return searchRepository.getAllUserWithSortByColumnsAndSearch(pageNo, pageSize, search, sortBy, User.class);
    }

    @Override
    public PageResponse<?> getAllTaskerWithSortByColumnsAndSearch(int pageNo, int pageSize, String search,
            String sortBy) {
        return searchRepository.getAllUserWithSortByColumnsAndSearch(pageNo, pageSize, search, sortBy, Tasker.class);
    }

    @Override
    public void saveAddress(long userId, AddressDTO req) {

        User user = (User) getUserById(userId);

        Address userAddress = Address.builder()
                .user(user)
                .addressName(req.getAddressName())
                .apartmentType(req.getApartmentType())
                .houserNumber(req.getHouseNumber())
                .longitude(req.getLongitude())
                .latitude(req.getLatitude())
                .isDefault(req.isDefault()).build();

        addressRepository.save(userAddress);

    }

    @Override
    public UserResponse getProfileUser(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Not found user with email"));

        return UserResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .firstLastName(user.getFirstLastName())
                .phoneNumber(user.getPhoneNumber())
                .profileImage(user.getProfileImage())
                .isActive(user.getIsActive())
                .lastLogin(user.getLastLogin())
                .build();
    }

}
