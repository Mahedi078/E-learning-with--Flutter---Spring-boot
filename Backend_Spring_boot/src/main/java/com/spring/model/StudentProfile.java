// src/main/java/com/spring/model/StudentProfile.java
package com.spring.model;

import javax.persistence.*;

@Entity
@Table(name = "students")
public class StudentProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable=false)
    private String name;

    @Column(unique = true, nullable=false)
    private String email;

    private int age;
    private String course;

    // store profile photo as bytes
    @Lob
    @Column(name = "image", columnDefinition = "LONGBLOB")
    private byte[] image;

    // getters/setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public byte[] getImage() { return image; }
    public void setImage(byte[] image) { this.image = image; }
}
