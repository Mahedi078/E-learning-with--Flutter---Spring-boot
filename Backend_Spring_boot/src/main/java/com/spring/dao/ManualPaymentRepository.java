package com.spring.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.model.ManualPayment;

public interface ManualPaymentRepository extends JpaRepository<ManualPayment, Long> {
    List<ManualPayment> findByEmail(String email);
    List<ManualPayment> findByStatus(String status);
}
