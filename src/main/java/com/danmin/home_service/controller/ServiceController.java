package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.ServiceCategoryDTO;
import com.danmin.home_service.dto.request.ServiceDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.ServicesService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@Slf4j(topic = "SERVICE-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Service Controller")
@RequestMapping("/service")
public class ServiceController {

    private final ServicesService servicesService;

    @Operation(summary = "Add service category")
    @PostMapping("/category/")
    public ResponseData<?> addServiceCategory(@RequestBody ServiceCategoryDTO req) {
        log.info("Saving service category...");

        try {
            servicesService.addServiceCategory(req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Added category successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Add category failure");
        }
    }

    @Operation(summary = "Update service category")
    @PutMapping("/update/{categoryId}")
    public ResponseData<?> updateServiceCategory(@PathVariable(value = "categoryId") long categoryId,
            @RequestBody ServiceCategoryDTO req) {
        log.info("Updating service category...");

        try {
            servicesService.updateCategory(categoryId, req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Updated category successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Updated category failure");
        }
    }

    @Operation(summary = "Delete service category")
    @DeleteMapping("/delete/{categoryId}")
    public ResponseData<?> deleteServiceCategory(@PathVariable(value = "categoryId") long categoryId) {
        log.info("Deleting service category...");

        try {
            servicesService.deleteCategory(categoryId);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Deleted category successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Deleted category failure");
        }
    }

    @Operation(summary = "Add service ")
    @PostMapping("/add-service/{categoryId}")
    public ResponseData<?> addService(@PathVariable(value = "categoryId") long categoryId,
            @RequestBody ServiceDTO req) {
        log.info("Saving service...");

        try {
            servicesService.addService(categoryId, req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Added service successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Add service failure");
        }
    }

    @Operation(summary = "Update service category")
    @PutMapping("/update-service/{serviceId}")
    public ResponseData<?> updateService(@PathVariable(value = "serviceId") long serviceId,
            @RequestBody ServiceDTO req) {
        log.info("Updating service category...");

        try {
            servicesService.updateService(serviceId, req);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Updated service successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Updated service failure");
        }
    }

    @Operation(summary = "Delete service category")
    @DeleteMapping("/delete-service/{serviceId}")
    public ResponseData<?> deleteService(@PathVariable(value = "serviceId") long serviceId) {
        log.info("Deleting service category...");

        try {
            servicesService.deleteService(serviceId);
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Deleted service successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Deleted service failure");
        }
    }

    @Operation(summary = "Get all service")
    @GetMapping("/list-service")
    public ResponseData<?> getAllService(@RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize) {
        log.info("Getting all user ");

        return new ResponseData<>(HttpStatus.OK.value(), "Servuce Category",
                servicesService.getAllService(pageNo, pageSize));
    }

}
