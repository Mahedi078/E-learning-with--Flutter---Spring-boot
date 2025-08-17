package com.spring.controller;

import com.spring.dao.EnrollmentRepository;
import com.spring.model.StudentCourseReportDTO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @GetMapping("/student-course-report")
    public ResponseEntity<List<StudentCourseReportDTO>> getStudentCourseReport() {
        List<StudentCourseReportDTO> report = enrollmentRepository.getStudentCourseReport();
        return ResponseEntity.ok(report);
    }
}
