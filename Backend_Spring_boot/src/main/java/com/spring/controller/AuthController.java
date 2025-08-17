//package com.spring.controller;
//
//import java.util.HashMap;
//import java.util.Map;
//import java.util.Optional;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.CrossOrigin;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import com.spring.dao.StudentRepository;
//import com.spring.model.Student;
//
//@RestController
//@RequestMapping("/api/auth")
//@CrossOrigin(origins = "http://localhost:4200")
//public class AuthController {
//
//    @Autowired
//    private StudentRepository studentRepo;
//
//    @PostMapping("/login")
//    public ResponseEntity<?> login(@RequestBody Map<String, String> loginData) {
//        String email = loginData.get("email");
//        String password = loginData.get("password");
//
//        Optional<Student> studentOpt = studentRepo.findByEmail(email);
//        if (studentOpt.isPresent()) {
//            Student student = studentOpt.get();
//            if (student.getPassword().equals(password)) {
//                // Fake token just for demo
//                Map<String, String> res = new HashMap<>();
//                res.put("token", "demo-jwt-token");
//                return ResponseEntity.ok(res);
//            }
//        }
//        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
//    }
//}
//
