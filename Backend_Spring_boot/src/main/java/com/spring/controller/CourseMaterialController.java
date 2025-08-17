package com.spring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.spring.dao.CourseMaterialRepository;
import com.spring.model.CourseMaterial;

@RestController
@RequestMapping("/api/materials")
@CrossOrigin(origins = "*")
public class CourseMaterialController {

    @Autowired
    private CourseMaterialRepository materialRepository;

    @GetMapping("/by-course/{courseId}")
    public List<CourseMaterial> getMaterialsByCourse(@PathVariable Long courseId) {
        return materialRepository.findByCourse_Id(courseId);
    }

    @PostMapping
    public CourseMaterial addMaterial(@RequestBody CourseMaterial material) {
        return materialRepository.save(material);

    }
    
    
}

