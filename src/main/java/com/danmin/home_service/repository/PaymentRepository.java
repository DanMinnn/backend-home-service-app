package com.danmin.home_service.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.Payments;

@Repository
public interface PaymentRepository extends JpaRepository<Payments, Long> {
    Optional<Payments> findByTransactionId(String transactionId);
}
