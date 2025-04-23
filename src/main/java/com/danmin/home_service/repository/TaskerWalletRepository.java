package com.danmin.home_service.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.danmin.home_service.model.TaskerWallet;

@Repository
public interface TaskerWalletRepository extends JpaRepository<TaskerWallet, Long> {

    Optional<TaskerWallet> findWalletByTaskerId(Integer taskerId);
}
