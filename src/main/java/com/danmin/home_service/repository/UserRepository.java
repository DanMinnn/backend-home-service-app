package com.danmin.home_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

}
