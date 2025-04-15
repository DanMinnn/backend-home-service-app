package com.danmin.home_service.service;

import com.danmin.home_service.dto.request.ServiceCategoryDTO;
import com.danmin.home_service.dto.request.ServiceDTO;
import com.danmin.home_service.dto.response.PageResponse;

public interface ServicesService {
    void addServiceCategory(ServiceCategoryDTO req);

    void updateCategory(long categoryId, ServiceCategoryDTO req);

    void deleteCategory(long categoryId);

    void addService(long categoryId, ServiceDTO req);

    void updateService(long serviceId, ServiceDTO req);

    void deleteService(long serviceId);

    PageResponse<?> getAllService(int pageNo, int pageSize);
}
