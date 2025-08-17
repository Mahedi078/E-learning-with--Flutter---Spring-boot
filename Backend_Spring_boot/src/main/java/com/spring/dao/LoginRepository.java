package com.spring.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.model.LoginData;

public interface LoginRepository extends JpaRepository<LoginData, Integer> {
}
