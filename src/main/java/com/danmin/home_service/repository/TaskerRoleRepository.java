package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Role;
import com.danmin.home_service.model.TaskerRole;

@Repository
public interface TaskerRoleRepository extends JpaRepository<TaskerRole, Integer> {
    @Query("SELECT tr.role FROM TaskerRole tr JOIN tr.tasker t WHERE t.email = :username")
    List<Role> findRolesByUsername(String username);

    @Query("SELECT tr FROM TaskerRole tr " +
            "JOIN FETCH tr.role r " +
            "JOIN FETCH r.rolePermissions rp " +
            "JOIN FETCH rp.permission " +
            "JOIN tr.tasker t WHERE t.email = :username")
    List<TaskerRole> findTaskerRolesWithPermissionsByUsername(String username);
}
