package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.PackageDTO;
import com.danmin.home_service.dto.request.ServiceCategoryDTO;
import com.danmin.home_service.dto.request.ServiceDTO;
import com.danmin.home_service.dto.request.VariantDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.ServicesService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.security.InvalidParameterException;

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
            return new ResponseData<>(HttpStatus.OK.value(), "Added category successfully");

        } catch (InvalidParameterException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
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
            return new ResponseData<>(HttpStatus.OK.value(), "Updated category successfully");

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
            return new ResponseData<>(HttpStatus.OK.value(), "Deleted category successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Deleted category failure");
        }
    }

    // ========================== SERVICE ==============================
    @Operation(summary = "Add service ")
    @PostMapping("/add-service/{categoryId}")
    public ResponseData<?> addService(@PathVariable(value = "categoryId") long categoryId,
            @RequestBody ServiceDTO req) {
        log.info("Saving service...");

        try {
            servicesService.addService(categoryId, req);
            return new ResponseData<>(HttpStatus.OK.value(), "Added service successfully");

        } catch (InvalidParameterException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
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
            return new ResponseData<>(HttpStatus.OK.value(), "Updated service successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Updated service failure");
        }
    }

    @Operation(summary = "Delete service")
    @DeleteMapping("/delete-service/{serviceId}")
    public ResponseData<?> deleteService(@PathVariable(value = "serviceId") long serviceId) {
        log.info("Deleting service...");

        try {
            servicesService.deleteService(serviceId);
            return new ResponseData<>(HttpStatus.OK.value(), "Deleted service successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Deleted service failure");
        }
    }

    // ========================== PACKAGE ==============================
    @Operation(summary = "Add package ")
    @PostMapping("/add-package/{serviceId}")
    public ResponseData<?> addPackage(@PathVariable(value = "serviceId") long serviceId,
            @RequestBody PackageDTO req) {
        log.info("Saving package...");

        try {
            servicesService.addPackage(serviceId, req);
            return new ResponseData<>(HttpStatus.OK.value(), "Added package successfully");

        } catch (InvalidParameterException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Add package failure");
        }
    }

    @Operation(summary = "Update package")
    @PutMapping("/update-package/{packageId}")
    public ResponseData<?> updatePackage(@PathVariable(value = "packageId") long packageId,
            @RequestBody PackageDTO req) {
        log.info("Updating package...");

        try {
            servicesService.updatePackage(packageId, req);
            return new ResponseData<>(HttpStatus.OK.value(), "Updated package successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Updated package failure");
        }
    }

    @Operation(summary = "Delete package")
    @DeleteMapping("/delete-package/{packageId}")
    public ResponseData<?> deletePackage(@PathVariable(value = "packageId") long packageId) {
        log.info("Deleting package...");

        try {
            servicesService.deletePackge(packageId);
            return new ResponseData<>(HttpStatus.OK.value(), "Deleted package successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Deleted package failure");
        }
    }

    // ========================== VARIANT ==============================
    @Operation(summary = "Add variant ")
    @PostMapping("/add-variant/{packageId}")
    public ResponseData<?> addVariant(@PathVariable(value = "packageId") long packageId,
            @RequestBody VariantDTO req) {
        log.info("Saving variant...");

        try {
            servicesService.addVariant(packageId, req);
            return new ResponseData<>(HttpStatus.OK.value(), "Added variant successfully");

        } catch (InvalidParameterException e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Add variant failure");
        }
    }

    @Operation(summary = "Update variant")
    @PutMapping("/update-variant/{variantId}")
    public ResponseData<?> updateVariant(@PathVariable(value = "variantId") long variantId,
            @RequestBody VariantDTO req) {
        log.info("Updating variant...");

        try {
            servicesService.updateVariant(variantId, req);
            return new ResponseData<>(HttpStatus.OK.value(), "Updated variant successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Updated variant failure");
        }
    }

    @Operation(summary = "Delete variant")
    @DeleteMapping("/delete-variant/{variantId}")
    public ResponseData<?> deleteVariant(@PathVariable(value = "variantId") long variantId) {
        log.info("Deleting package...");

        try {
            servicesService.deleteVariant(variantId);
            return new ResponseData<>(HttpStatus.OK.value(), "Deleted variant successfully");

        } catch (Exception e) {
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Deleted variant failure");
        }
    }

    @Operation(summary = "Get all service")
    @GetMapping("/list-service")
    public ResponseData<?> getAllService(@RequestParam(defaultValue = "0", required = false) int pageNo,
            @RequestParam(defaultValue = "10", required = false) int pageSize) {
        log.info("Getting all service ");

        return new ResponseData<>(HttpStatus.OK.value(), "Service Category",
                servicesService.getAllService(pageNo, pageSize));
    }

    @Operation(summary = "Get all service with packages")
    @GetMapping("/list-service-package/{service-id}")
    public ResponseData<?> getAllServiceWithPackages(@PathVariable(value = "service-id") Long serviceId) {
        log.info("Getting all service with packages ");

        return new ResponseData<>(HttpStatus.OK.value(), "Service with packages",
                servicesService.getServiceWithPackages(serviceId));
    }

}
