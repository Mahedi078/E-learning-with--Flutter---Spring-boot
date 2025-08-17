// src/main/java/com/spring/controller/StudentProfileController.java
package com.spring.controller;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.*;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.spring.dao.StudentProfileRepository;
import com.spring.dto.StudentProfileDTO;
import com.spring.model.StudentProfile;

@RestController
@RequestMapping("/api/students")
@CrossOrigin(origins = "*")
public class StudentProfileController {

    @Autowired
    private StudentProfileRepository studentRepo;

    // 1) Auto-create profile once per email (call this after login)
    @GetMapping("/auto-create/{email}")
    public ResponseEntity<?> autoCreate(@PathVariable String email) {
        Optional<StudentProfile> existing = studentRepo.findByEmail(email);
        if (!existing.isPresent()) {
            StudentProfile p = new StudentProfile();
            p.setEmail(email);
            p.setName("New Student");
            p.setAge(0);
            p.setCourse("Unknown");
            p.setImage(null);
            studentRepo.save(p);
        }
        return ResponseEntity.ok("Profile ready");
    }

    // 2) Get profile by email (Flutter will call this to show real data)
    @GetMapping("/{email}")
    public ResponseEntity<?> getByEmail(@PathVariable String email) {
        Optional<StudentProfile> st = studentRepo.findByEmail(email);
        if (st.isPresent()) {
            StudentProfile s = st.get();
            String imgUrl = "/api/students/image/" + s.getEmail();
            return ResponseEntity.ok(
                new StudentProfileDTO(s.getId(), s.getName(), s.getEmail(), s.getAge(), s.getCourse(), imgUrl)
            );
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Student not found");
    }


    // 3) Return image; if null, return default placeholder so NetworkImage doesn't 404
    @GetMapping("/image/{email}")
    public ResponseEntity<byte[]> getImage(@PathVariable String email) {
        Optional<StudentProfile> st = studentRepo.findByEmail(email);
        if (st.isPresent() && st.get().getImage() != null) {
            return ResponseEntity.ok().contentType(MediaType.IMAGE_JPEG).body(st.get().getImage());
        }
        try {
            ClassPathResource img = new ClassPathResource("static/default_student.jpg");
            byte[] bytes = StreamUtils.copyToByteArray(img.getInputStream());
            return ResponseEntity.ok().contentType(MediaType.IMAGE_JPEG).body(bytes);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

  
    
    @PutMapping(value="/update-with-image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> updateWithImage(
            @RequestParam String email,
            @RequestParam String name,
            @RequestParam int age,
            @RequestParam String course,
            @RequestParam(value="image", required=false) MultipartFile imageFile) {

        Optional<StudentProfile> opt = studentRepo.findByEmail(email);
        if (!opt.isPresent()) return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Student not found");

        try {
            StudentProfile s = opt.get();
            s.setName(name);
            s.setAge(age);
            s.setCourse(course);
            if (imageFile != null && !imageFile.isEmpty()) {
                s.setImage(imageFile.getBytes());
            }
            studentRepo.save(s);

            String imgUrl = "/api/students/image/" + s.getEmail();
            StudentProfileDTO dto = new StudentProfileDTO(
                s.getId(), s.getName(), s.getEmail(), s.getAge(), s.getCourse(), imgUrl
            );
            return ResponseEntity.ok(dto);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to update: "+e.getMessage());
        }
    }

    
}