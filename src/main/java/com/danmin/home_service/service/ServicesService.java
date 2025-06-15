package com.danmin.home_service.service;

import com.danmin.home_service.dto.request.PackageDTO;
import com.danmin.home_service.dto.request.ServiceCategoryDTO;
import com.danmin.home_service.dto.request.ServiceDTO;
import com.danmin.home_service.dto.request.VariantDTO;
import com.danmin.home_service.dto.response.PageResponse;
import com.danmin.home_service.dto.response.ServicePackageResponse;

public interface ServicesService {
    void addServiceCategory(ServiceCategoryDTO req);

    void updateCategory(long categoryId, ServiceCategoryDTO req);

    void deleteCategory(long categoryId);

    void addService(long categoryId, ServiceDTO req);

    void updateService(long serviceId, ServiceDTO req);

    void deleteService(long serviceId);

    void addPackage(long serviceId, PackageDTO packageDTO);

    void updatePackage(long packageId, PackageDTO packageDTO);

    void deletePackge(long packageId);

    void addVariant(long packageId, VariantDTO variantDTO);

    void updateVariant(long variantId, VariantDTO variantDTO);

    void deleteVariant(long variantId);

    PageResponse<?> getAllService(int pageNo, int pageSize);

    ServicePackageResponse getServiceWithPackages(Long id);
}
