package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Role;
import com.danmin.home_service.model.UserRole;

@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, Integer> {
    @Query("SELECT ur.role FROM UserRole ur JOIN ur.user u WHERE u.email = :username")
    List<Role> findRolesByUsername(String username);
}
