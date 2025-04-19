package com.danmin.home_service.service;

import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.danmin.home_service.model.Permission;
import com.danmin.home_service.model.Role;
import com.danmin.home_service.repository.RolePermissionRepository;
import com.danmin.home_service.repository.TaskerRoleRepository;
import com.danmin.home_service.repository.UserRoleRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PermissionService {

    private final UserRoleRepository userRoleRepository;
    private final RolePermissionRepository rolePermissionRepository;
    private final TaskerRoleRepository taskerRoleRepository;

    public boolean checkUserHasPermission(String username, String method, String uri) {
        List<Role> userRoles = userRoleRepository.findRolesByUsername(username);

        if (userRoles.stream().anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()))) {
            return true;
        }

        List<Integer> rolesId = userRoles.stream().map(Role::getId).collect(Collectors.toList());

        if (rolesId.isEmpty()) {
            return false;
        }

        List<Permission> permissions = rolePermissionRepository.findPermissionsByRoleIds(rolesId);

        return permissions.stream().anyMatch(permission -> {
            if (!permission.getMethods().equals(method)) {
                return false;
            }

            String methodPath = permission.getMethodPath();

            if (methodPath.equals(uri)) {
                return true;
            }

            try {
                return Pattern.compile(methodPath).matcher(uri).matches();
            } catch (Exception e) {
                // if regex invalid, don't match
                return false;
            }
        });

    }

    public boolean checkTaskerHasPermission(String username, String method, String uri) {
        List<Role> taskerRole = taskerRoleRepository.findRolesByUsername(username);

        if (taskerRole.stream().anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()))) {
            return true;
        }

        List<Integer> rolesId = taskerRole.stream().map(Role::getId).collect(Collectors.toList());

        if (rolesId.isEmpty()) {
            return false;
        }

        List<Permission> permissions = rolePermissionRepository.findPermissionsByRoleIds(rolesId);

        return permissions.stream().anyMatch(permission -> {
            if (!permission.getMethods().equals(method)) {
                return false;
            }

            String methodPath = permission.getMethodPath();

            if (methodPath.equals(uri)) {
                return true;
            }

            try {
                return Pattern.compile(methodPath).matcher(uri).matches();
            } catch (Exception e) {
                // if regex invalid, don't match
                return false;
            }
        });

    }
}
