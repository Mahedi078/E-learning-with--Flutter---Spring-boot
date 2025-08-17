// src/main/java/com/spring/dto/StudentProfileDTO.java
package com.spring.dto;

public class StudentProfileDTO {
    private Long id;
    private String name;
    private String email;
    private int age;
    private String course;
    private String imageUrl; // backend থেকে URL ফেরত দিবে

    public StudentProfileDTO(Long id, String name, String email, int age, String course, String imageUrl) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.age = age;
        this.course = course;
        this.imageUrl = imageUrl;
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getCourse() {
		return course;
	}

	public void setCourse(String course) {
		this.course = course;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

    // getters/setters
}
