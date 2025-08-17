package com.spring.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.model.Question;

public interface QuestionRepository extends JpaRepository<Question, Long> {}
