package com.spring.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.model.Quiz;

public interface QuizRepository extends JpaRepository<Quiz, Long> {

	List<Quiz> findAll();

	}
