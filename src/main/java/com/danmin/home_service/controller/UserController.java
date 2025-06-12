package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.danmin.home_service.dto.request.AddressDTO;
import com.danmin.home_service.dto.request.UserDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.ImageService;
import com.danmin.home_service.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PostMapping;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@Slf4j(topic = "USER-CONTROLLER")
@Tag(name = "User Controller")
public class UserController {

    private final UserService userService;
    private final ImageService imageService;

    @Operation(summary = "Get profile user")
    @GetMapping("/profile/{email}")
    public ResponseData<?> getProfileUser(@PathVariable(value = "email") String email) {

        try {
            return new ResponseData<>(HttpStatus.OK.value(), "User profile", userService.getProfileUser(email));
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @Operation(summary = "Update user", description = "Deprecated: Use /update-with-image/{userId} endpoint instead for a more efficient approach that handles both user data and image updates.")
    @PostMapping("/update/{userId}")
    @Deprecated(since = "1.1", forRemoval = false)
    public ResponseData<?> updateUser(@PathVariable(value = "userId") long userId, @Valid @RequestBody UserDTO req) {
        log.info("Updating user with id={}", userId);

        try {
            userService.updateProfileUser(userId, req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Updated user successfully !");
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @Operation(summary = "Upload image", description = "Deprecated: Use /update-with-image/{userId} endpoint instead for a more efficient approach that handles both user data and image updates.")
    @PostMapping("/upload")
    @Deprecated(since = "1.1", forRemoval = false)
    public ResponseData<?> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            String url = imageService.uploadImage(file);
            return new ResponseData<>(HttpStatus.OK.value(), "Upload successfully", url);
        } catch (IOException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Image upload failed");
        }
    }

    @Operation(summary = "Delete user")
    @DeleteMapping("/delete/{userId}")
    public ResponseData<?> deleteAccount(@PathVariable(value = "userId") long userId) {
        log.info("Deleting user with id={}", userId);

        try {
            userService.deleteAccount(userId);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Deleted user successfully !");
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @Operation(summary = "Get all users")
    @GetMapping("/list-users")
    public ResponseData<?> getAllUsers(@RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize) {
        log.info("Getting all user ");

        return new ResponseData<>(HttpStatus.OK.value(), "users", userService.getAllUser(pageNo, pageSize));
    }

    @Operation(summary = "Get all users by search and sort")
    @GetMapping("/sort-by-column-and-search")
    public ResponseData<?> getAllUserWithSortByColumnsAndSearch(
            @RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "sortBy", required = false) String sortBy) {

        log.info("Getting all users ");

        return new ResponseData<>(HttpStatus.OK.value(), "users",
                userService.getAllUserWithSortByColumnsAndSearch(pageNo, pageSize, search, sortBy));
    }

    @Operation(summary = "Get all tasker by search and sort")
    @GetMapping("/sort-tasker-by-column-and-search")
    public ResponseData<?> getAllTaskerWithSortByColumnsAndSearch(
            @RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "sortBy", required = false) String sortBy) {

        log.info("Getting all taskers ");

        return new ResponseData<>(HttpStatus.OK.value(), "users",
                userService.getAllTaskerWithSortByColumnsAndSearch(pageNo, pageSize, search, sortBy));
    }

    @Operation(summary = "Get all taskers")
    @GetMapping("/list-taskers")
    public ResponseData<?> getAllTaskers(@RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize) {
        log.info("Getting all user ");

        return new ResponseData<>(HttpStatus.OK.value(), "taskers", userService.getAllTasker(pageNo, pageSize));
    }

    @Operation(summary = "Add user's address")
    @PostMapping("/address/{userId}")
    public ResponseData<?> saveAddress(@PathVariable(value = "userId") long userId, @RequestBody AddressDTO req) {

        log.info("Saving address user with id={}", userId);

        try {
            userService.saveAddress(userId, req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Saved user's address successfully !");
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @Operation(summary = "Update user with profile image")
    @PostMapping(value = "/update-with-image/{userId}", consumes = { "multipart/form-data" })
    public ResponseData<?> updateUserWithImage(
            @PathVariable(value = "userId") long userId,
            @RequestParam(value = "firstLastName", required = false) String firstLastName,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage) {

        log.info("Updating user with id={} including image", userId);

        try {
            // Create UserDTO with the form data
            UserDTO userDTO = new UserDTO();
            userDTO.setFirstLastName(firstLastName);
            userDTO.setAddress(address);

            // Upload the image and set the URL in the DTO
            if (profileImage != null && !profileImage.isEmpty()) {
                String imageUrl = imageService.uploadImage(profileImage);
                userDTO.setProfileImage(imageUrl);
            }

            // Update the user with the DTO containing all information
            userService.updateProfileUser(userId, userDTO);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Updated user with image successfully!");
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

}
