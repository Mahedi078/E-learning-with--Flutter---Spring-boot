package com.spring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.model.CourseCategory;
import com.spring.service.CourseCategoryService;

@RestController
@RequestMapping("/course-categories")
@CrossOrigin(origins = "http://localhost:4200")
public class CourseCategoryController {

    @Autowired
    private CourseCategoryService service;

    @PostMapping
    public CourseCategory addCategory(@RequestBody CourseCategory category) {
        return service.save(category);
    }

    @GetMapping
    public List<CourseCategory> getAllCategories() {
        return service.getAll();
    }
}
