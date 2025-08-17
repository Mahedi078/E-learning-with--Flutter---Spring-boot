package com.spring.dao;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.Query; // ✅ Correct import
import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.model.Enrollment;
import com.spring.model.Enrollment.EnrollmentStatus;
import com.spring.model.StudentCourseReportDTO;

public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    List<Enrollment> findByStatus(EnrollmentStatus status);

    Optional<Enrollment> findByEmail(String email);

    // <-- Add this method:
    List<Enrollment> findByEmailAndStatus(String email, EnrollmentStatus status);

	
    @Query("SELECT new com.spring.model.StudentCourseReportDTO(e.name, e.email, c.title, e.status) " +
    	       "FROM Enrollment e JOIN e.course c")
    	List<StudentCourseReportDTO> getStudentCourseReport();

    	
    
}
