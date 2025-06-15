package com.danmin.home_service.service.impl;

import java.math.BigDecimal;
import java.security.InvalidParameterException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.danmin.home_service.dto.request.PackageDTO;
import com.danmin.home_service.dto.request.ServiceCategoryDTO;
import com.danmin.home_service.dto.request.ServiceDTO;
import com.danmin.home_service.dto.request.VariantDTO;
import com.danmin.home_service.dto.response.PageResponse;
import com.danmin.home_service.dto.response.ServicePackageResponse;
import com.danmin.home_service.dto.response.ServiceResponse;
import com.danmin.home_service.dto.response.CategoriesWithServicesResponse;
import com.danmin.home_service.dto.response.PackageResponse;
import com.danmin.home_service.dto.response.PackageVariantsResponse;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.PackageVariants;
import com.danmin.home_service.model.ServiceCategory;
import com.danmin.home_service.model.ServicePackages;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.repository.PackageVariantRepository;
import com.danmin.home_service.repository.ServiceCatetoryRepository;
import com.danmin.home_service.repository.ServicePackageRepository;
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
    private final ServicePackageRepository servicePackageRepository;
    private final PackageVariantRepository packageVariantRepository;

    @Override
    public void addServiceCategory(ServiceCategoryDTO req) {

        if (req.getCategoryName() == null || req.getIsActive() == null) {
            throw new InvalidParameterException("Those fields are required!");
        }

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
        sCategory.setIsDeleted(true);
        sCatetoryRepository.save(sCategory);
    }

    private Services getServicesById(long serviceId) {
        return serviceRepository.findById(serviceId)
                .orElseThrow(() -> new ResourceNotFoundException("Service not found"));
    }

    // ------------------ SERVICE ----------------------
    @Override
    public void addService(long categoryId, ServiceDTO req) {
        ServiceCategory serviceCategory = getCategoryId(categoryId);

        if (req.getName() == null || req.getDes() == null) {
            throw new InvalidParameterException("Name and des services are required!");
        }
        Services services = Services.builder().category(serviceCategory).name(req.getName()).description(req.getDes())
                .isActive(req.getIsActive()).build();
        serviceRepository.save(services);
    }

    @Override
    public void updateService(long serviceId, ServiceDTO req) {
        Services services = getServicesById(serviceId);

        if (req.getName() != null) {
            services.setName(req.getName());
        }

        services.setDescription(req.getDes());

        if (req.getIsActive() != null) {
            services.setIsActive(req.getIsActive());
        }

        serviceRepository.save(services);
    }

    @Override

    public void deleteService(long serviceId) {
        Services services = getServicesById(serviceId);

        services.setIsDeleted(true);
        serviceRepository.save(services);
    }

    // ------------------ PACKAGE ----------------------
    @Override
    public void addPackage(long serviceId, PackageDTO packageDTO) {
        Services services = serviceRepository.findById(serviceId)
                .orElseThrow(() -> new ResourceNotFoundException("Service not found!"));

        if (packageDTO.getPackageName() == null || packageDTO.getPackageDescription() == null
                || packageDTO.getPackagePrice() == null) {
            throw new InvalidParameterException("Those fields are required!");
        }

        servicePackageRepository.save(ServicePackages.builder()
                .services(services)
                .packageName(packageDTO.getPackageName())
                .packageDescription(packageDTO.getPackageDescription())
                .basePrice(packageDTO.getPackagePrice()).build());
    }

    @Override
    public void updatePackage(long packageId, PackageDTO packageDTO) {
        ServicePackages packages = servicePackageRepository.findById(packageId)
                .orElseThrow(() -> new ResourceNotFoundException("Package not found!"));

        if (packageDTO.getPackageName() != null)
            packages.setPackageName(packageDTO.getPackageName());

        if (packageDTO.getPackageDescription() != null)
            packages.setPackageDescription(packageDTO.getPackageDescription());

        if (packageDTO.getPackagePrice() != null)
            packages.setBasePrice(packageDTO.getPackagePrice());

        servicePackageRepository.save(packages);
    }

    @Override
    public void deletePackge(long packageId) {
        ServicePackages packages = servicePackageRepository.findById(packageId)
                .orElseThrow(() -> new ResourceNotFoundException("Package not found!"));

        packages.setIsDeleted(true);
        servicePackageRepository.delete(packages);
    }

    // ------------------ VARIANT ----------------------
    @Override
    public void addVariant(long packageId, VariantDTO variantDTO) {
        ServicePackages packages = servicePackageRepository.findById(packageId)
                .orElseThrow(() -> new ResourceNotFoundException("Package not found !"));

        if (variantDTO.getVariantName() == null
                || variantDTO.getVariantDes() == null
                || variantDTO.getAdditionalPrice() == null) {
            throw new InvalidParameterException("Those fields are required!");
        }

        packageVariantRepository.save(PackageVariants.builder().servicePackages(packages)
                .variantName(variantDTO.getVariantName())
                .variantDescription(variantDTO.getVariantDes())
                .additionalPrice(variantDTO.getAdditionalPrice()).build());

    }

    @Override
    public void updateVariant(long variantId, VariantDTO variantDTO) {
        PackageVariants variants = packageVariantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variant not found !"));

        String variantName = variantDTO.getVariantName();
        String variantDes = variantDTO.getVariantDes();
        BigDecimal variantPrice = variantDTO.getAdditionalPrice();

        if (variantName != null)
            variants.setVariantName(variantName);
        if (variantDes != null)
            variants.setVariantDescription(variantDes);
        if (variantPrice != null)
            variants.setAdditionalPrice(variantPrice);

        packageVariantRepository.save(variants);
    }

    @Override
    public void deleteVariant(long variantId) {
        PackageVariants variants = packageVariantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variant not found !"));

        variants.setIsDeleted(true);
        packageVariantRepository.delete(variants);
    }

    @Override
    public PageResponse<?> getAllService(int pageNo, int pageSize) {

        List<ServiceCategory> categoryPage = sCatetoryRepository.findAllServiceCategories();

        List<Integer> categoryIds = categoryPage.stream()
                .map(ServiceCategory::getId)
                .collect(Collectors.toList());

        List<ServiceCategory> categoriesWithSortedServices = new ArrayList<>();

        if (!categoryIds.isEmpty()) {
            categoriesWithSortedServices = sCatetoryRepository.findCategoriesWithSortedServicesByIds(categoryIds);
        }

        List<CategoriesWithServicesResponse> responses = categoriesWithSortedServices.stream()
                .map(category -> {
                    // Sort services by name
                    List<Services> sortedServices = new ArrayList<>(category.getServices());
                    sortedServices.sort(Comparator.comparing(Services::getName, String.CASE_INSENSITIVE_ORDER));

                    Set<ServiceResponse> services = sortedServices.stream()
                            .map(
                                    service -> ServiceResponse.builder()
                                            .id(service.getId())
                                            .name(service.getName())
                                            .description(service.getDescription())
                                            .icon(service.getIcon())
                                            .isActive(service.getIsActive())
                                            .isDeleted(service.getIsDeleted())
                                            .build())
                            .collect(Collectors.toCollection(LinkedHashSet::new));

                    return CategoriesWithServicesResponse.builder()
                            .id(category.getId())
                            .name(category.getName())
                            .isActive(category.getIsActive())
                            .isDeleted(category.getIsDeleted())
                            .services(services)
                            .build();
                })
                .collect(Collectors.toList());

        int totalItems = responses.size();
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

        List<CategoriesWithServicesResponse> paged = responses.subList(start, end);

        return PageResponse.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .items(paged)
                .build();
    }

    @Transactional
    @Override
    public ServicePackageResponse getServiceWithPackages(Long id) {

        Services service = serviceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Service not found"));

        List<PackageResponse> sortedPackages = service.getServicePackages().stream()
                .sorted(Comparator.comparing(ServicePackages::getId))
                .map(
                        pkg -> {
                            Set<PackageVariantsResponse> sortedVariants = pkg.getPackageVariants().stream()
                                    .sorted(Comparator.comparing(PackageVariants::getId))
                                    .map(variant -> PackageVariantsResponse.builder()
                                            .id(variant.getId())
                                            .name(variant.getVariantName())
                                            .description(variant.getVariantDescription())
                                            .additionalPrice(variant.getAdditionalPrice())
                                            .isDeleted(variant.getIsDeleted())
                                            .build())
                                    .collect(Collectors.toCollection(LinkedHashSet::new));

                            return PackageResponse.builder()
                                    .id(pkg.getId())
                                    .name(pkg.getPackageName())
                                    .description(pkg.getPackageDescription())
                                    .basePrice(pkg.getBasePrice())
                                    .variants(sortedVariants)
                                    .isDeleted(pkg.getIsDeleted())
                                    .build();
                        })
                .collect(Collectors.toList());

        // Convert the sorted list back to a set to match the expected return type
        Set<PackageResponse> responses = new LinkedHashSet<>(sortedPackages);

        return ServicePackageResponse.builder()
                .id(service.getId())
                .name(service.getName())
                .isActive(service.getIsActive())
                .servicePackages(responses)
                .isDeleted(service.getIsDeleted())
                .build();
    }

}
