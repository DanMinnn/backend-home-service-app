package com.danmin.home_service.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.danmin.home_service.model.UserTransaction;

@Repository
public interface UserTransactionRepository extends JpaRepository<UserTransaction, UUID> {

    Optional<UserTransaction> findTransactionByUserId(Integer userId);
}
