package com.danmin.home_service.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.TaskerServiceDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.ImageService;
import com.danmin.home_service.service.TaskerService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/tasker")
@RequiredArgsConstructor
@Slf4j(topic = "TASKER-CONTROLLER")
@Tag(name = "Tasker Controller")
public class TaskerController {
    private final TaskerService taskerService;
    private final ImageService imageService;

    @Operation(summary = "Get profile tasker")
    @GetMapping("/profile/{email}")
    public ResponseData<?> getProfileTasker(@PathVariable(value = "email") String email) {

        try {
            return new ResponseData<>(HttpStatus.OK.value(), "Tasker profile", taskerService.getProfileTasker(email));
        } catch (Exception e) {
            log.error("errorMessage={}", e.getMessage(), e.getCause());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        }
    }

    @Operation(summary = "Add tasker with service")
    @PostMapping("/add-tasker-service/")
    public ResponseData<?> addTaskerWithService(@RequestBody TaskerServiceDTO req) {
        taskerService.addTaskerService(req);
        return new ResponseData<>(HttpStatus.OK.value(), "Add successfully");
    }
}
