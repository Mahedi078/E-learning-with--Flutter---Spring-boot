// src/main/java/com/spring/dao/StudentProfileRepository.java
package com.spring.dao;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.spring.model.StudentProfile;

public interface StudentProfileRepository extends JpaRepository<StudentProfile, Long> {
    Optional<StudentProfile> findByEmail(String email);
}
