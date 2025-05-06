package com.danmin.home_service.service.impl;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.request.ServiceCategoryDTO;
import com.danmin.home_service.dto.request.ServiceDTO;
import com.danmin.home_service.dto.response.PageResponse;
import com.danmin.home_service.dto.response.ServiceResponse;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.ServiceCategory;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.repository.ServiceCatetoryRepository;
import com.danmin.home_service.repository.ServiceRepository;
import com.danmin.home_service.service.ServicesService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ServicesServiceImpl implements ServicesService {

    private final ServiceCatetoryRepository sCatetoryRepository;
    private final ServiceRepository serviceRepository;

    @Override
    public void addServiceCategory(ServiceCategoryDTO req) {

        ServiceCategory category = ServiceCategory.builder()
                .name(req.getCategoryName())
                .isActive(req.getIsActive())
                .build();
        sCatetoryRepository.save(category);
    }

    private ServiceCategory getCategoryId(long categoryId) {
        return sCatetoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found"));
    }

    @Override
    public void updateCategory(long categoryId, ServiceCategoryDTO req) {
        ServiceCategory sCategory = getCategoryId(categoryId);

        if (req.getCategoryName() != null) {
            sCategory.setName(req.getCategoryName());
        }

        if (req.getIsActive() != null) {
            sCategory.setIsActive(req.getIsActive());
        }

        sCatetoryRepository.save(sCategory);
    }

    @Override
    public void deleteCategory(long categoryId) {
        ServiceCategory sCategory = getCategoryId(categoryId);
        sCategory.setIsActive(false);
        sCatetoryRepository.save(sCategory);
    }

    private Services getServicesById(long serviceId) {
        return serviceRepository.findById(serviceId)
                .orElseThrow(() -> new ResourceNotFoundException("Service not found"));
    }

    @Override
    public void addService(long categoryId, ServiceDTO req) {
        ServiceCategory serviceCategory = getCategoryId(categoryId);

        Services services = Services.builder().category(serviceCategory).name(req.getName()).description(req.getDes())
                .basePrice(req.getBasePrice()).isActive(req.getIsActive()).build();
        serviceRepository.save(services);
    }

    @Override
    public void updateService(long serviceId, ServiceDTO req) {
        Services services = getServicesById(serviceId);

        if (req.getName() != null) {
            services.setName(req.getName());
        }

        services.setDescription(req.getDes());

        if (req.getBasePrice() != null) {
            services.setBasePrice(req.getBasePrice());
        }

        if (req.getIsActive() != null) {
            services.setIsActive(req.getIsActive());
        }

        serviceRepository.save(services);
    }

    @Override

    public void deleteService(long serviceId) {
        Services services = getServicesById(serviceId);

        services.setIsActive(false);
        serviceRepository.save(services);
    }

    @Override
    public PageResponse<?> getAllService(int pageNo, int pageSize) {
        int page = 0;

        if (pageNo > 0)
            page = pageNo - 1;

        Pageable pageable = PageRequest.of(page, pageSize);

        Page<ServiceCategory> categoryPage = sCatetoryRepository.findAllServiceCategories(pageable);

        List<Integer> categoryIds = categoryPage.getContent().stream()
                .map(ServiceCategory::getId)
                .collect(Collectors.toList());

        List<ServiceCategory> categoriesWithSortedServices = new ArrayList<>();

        if (!categoryIds.isEmpty()) {
            categoriesWithSortedServices = sCatetoryRepository.findCategoriesWithSortedServicesByIds(categoryIds);
        }

        List<ServiceResponse> responses = categoriesWithSortedServices.stream()
                .map(category -> {
                    // Sort services by name
                    List<Services> sortedServices = new ArrayList<>(category.getServices());
                    sortedServices.sort(Comparator.comparing(Services::getName, String.CASE_INSENSITIVE_ORDER));
                    Set<Services> orderedServices = new LinkedHashSet<>(sortedServices);

                    // Create response with sorted services
                    return ServiceResponse.builder()
                            .id(category.getId())
                            .name(category.getName())
                            .isActive(category.getIsActive())
                            .services(orderedServices) // Use sorted services here
                            .build();
                })
                .collect(Collectors.toList());

        return PageResponse.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .items(responses)
                .build();
    }

}
