package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.UserDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@Slf4j(topic = "USER-CONTROLLER")
@Tag(name = "User Controller")
public class UserController {

    private final UserService userService;

    @Operation(summary = "Update user")
    @PutMapping("/update/{userId}")
    public ResponseData<?> updateUSer(@PathVariable(value = "userId") long userId, @Valid @RequestBody UserDTO req) {
        log.info("Updating user with id={}", userId);

        try {
            userService.updateProfileUser(userId, req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Updated user successfully !");
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
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
    @GetMapping("/list")
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
    @GetMapping("/list")
    public ResponseData<?> getAllTaskers(@RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize) {
        log.info("Getting all user ");

        return new ResponseData<>(HttpStatus.OK.value(), "taskers", userService.getAllTasker(pageNo, pageSize));
    }

}
