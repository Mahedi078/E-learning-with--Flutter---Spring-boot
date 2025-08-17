package com.spring.dao;



import org.springframework.data.jpa.repository.JpaRepository;
import com.spring.model.CourseCategory;

public interface CourseCategoryRepository extends JpaRepository<CourseCategory, Long> {}
