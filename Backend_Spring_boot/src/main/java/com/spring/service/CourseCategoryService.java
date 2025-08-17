package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.CourseCategoryRepository;
import com.spring.model.CourseCategory;

@Service
public class CourseCategoryService {

    @Autowired
    private CourseCategoryRepository repository;

    public CourseCategory save(CourseCategory category) {
        return repository.save(category);
    }

    public List<CourseCategory> getAll() {
        return repository.findAll();
    }
}

