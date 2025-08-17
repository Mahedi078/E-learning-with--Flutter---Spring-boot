package com.spring.dao;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.spring.model.CourseMaterial;

public interface CourseMaterialRepository extends JpaRepository<CourseMaterial, Long> {
    List<CourseMaterial> findByCourse_Id(Long courseId);  // ✅ Correct method name
}
