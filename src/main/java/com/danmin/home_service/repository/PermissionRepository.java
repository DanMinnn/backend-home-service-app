package com.danmin.home_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Permission;

@Repository
public interface PermissionRepository extends JpaRepository<Permission, Integer> {
    Permission findByMethodsAndMethodPath(String methods, String methodPath);
}
