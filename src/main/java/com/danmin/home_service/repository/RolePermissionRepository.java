package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Permission;
import com.danmin.home_service.model.Role_Permission;

@Repository
public interface RolePermissionRepository extends JpaRepository<Role_Permission, Integer> {
    @Query("SELECT rp.permission FROM Role_Permission rp WHERE rp.role.id IN :roleIds")
    List<Permission> findPermissionsByRoleIds(List<Integer> roleIds);
}
