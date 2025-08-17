package com.spring.controller;

import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.spring.dao.CourseRepository;
import com.spring.dao.EnrollmentRepository;
import com.spring.model.Course;
import com.spring.model.Enrollment;
import com.spring.model.Enrollment.EnrollmentStatus;

@RestController
@RequestMapping("/api/enrollments")
@CrossOrigin(origins = "*") 
public class EnrollmentController {

    @Autowired
    private EnrollmentRepository repository;
    
    @Autowired
    private CourseRepository courseRepository;

    
    @GetMapping("/courses/{email}")
    public List<Course> getCoursesByStudentEmail(@PathVariable String email) {
        List<Enrollment> enrollments = repository.findByEmailAndStatus(email, EnrollmentStatus.APPROVED);
        return enrollments.stream()
                .map(Enrollment::getCourse)
                .collect(Collectors.toList());
    }

    
    
    @GetMapping("/by-email/{email}")
    public ResponseEntity<?> getEnrollmentByEmail(@PathVariable String email) {
        Optional<Enrollment> optional = repository.findByEmail(email);
        if (optional.isPresent()) {
            Enrollment enrollment = optional.get();

            double price = 0;
            String courseTitle = "";

            if (enrollment.getCourse() != null) {
                price = enrollment.getCourse().getPrice();
                courseTitle = enrollment.getCourse().getTitle();
            }

            Map<String, Object> response = new HashMap<>();
            response.put("id", enrollment.getId());
            response.put("name", enrollment.getName());
            response.put("email", enrollment.getEmail());
           
            response.put("coursePrice", price);
            response.put("status", enrollment.getStatus());
            response.put("course", enrollment.getCourse());

            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/status")
    public Enrollment getEnrollmentStatus(@RequestParam String email) {
        return repository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("Enrollment not found for email: " + email));
    }

    @PostMapping
    public Enrollment createEnrollment(@RequestBody Enrollment enrollment) {
        Long courseId = enrollment.getCourse().getId();

        Course course = courseRepository.findById(courseId)
            .orElseThrow(() -> new RuntimeException("Course not found with id: " + courseId));

        enrollment.setCourse(course);
        enrollment.setStatus(EnrollmentStatus.PENDING);

        return repository.save(enrollment);
    }

    @GetMapping("/pending")
    public List<Enrollment> getPendingEnrollments() {
        return repository.findByStatus(EnrollmentStatus.PENDING);
    }

    @PutMapping("/{id}/approve")
    public Enrollment approveEnrollment(@PathVariable Long id) {
        Enrollment enrollment = repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Enrollment not found with id: " + id));

        enrollment.setStatus(EnrollmentStatus.APPROVED);
        return repository.save(enrollment);
    }

    @PutMapping("/{id}/reject")
    public Enrollment rejectEnrollment(@PathVariable Long id) {
        Enrollment enrollment = repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Enrollment not found with id: " + id));

        enrollment.setStatus(EnrollmentStatus.REJECTED);
        return repository.save(enrollment);
    }
    
    @GetMapping("/approved/{email}")
    public List<Course> getApprovedCoursesByStudent(@PathVariable String email) {
        List<Enrollment> enrollments = repository.findByEmailAndStatus(email, EnrollmentStatus.APPROVED);
        return enrollments.stream()
                .map(Enrollment::getCourse)
                .collect(Collectors.toList());
    }
    
    @GetMapping
    public ResponseEntity<List<Enrollment>> getAllEnrollments() {
        List<Enrollment> enrollments = repository.findAll();
        return ResponseEntity.ok(enrollments);
    }
    

    }

