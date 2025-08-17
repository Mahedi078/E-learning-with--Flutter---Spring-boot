package com.spring.model;


public class StudentCourseReportDTO {

    public String getStudentName() {
		return studentName;
	}

	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}

	public String getStudentEmail() {
		return studentEmail;
	}

	public void setStudentEmail(String studentEmail) {
		this.studentEmail = studentEmail;
	}

	public String getCourseTitle() {
		return courseTitle;
	}

	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}

	public String getFinancialStatus() {
		return financialStatus;
	}

	public void setFinancialStatus(String financialStatus) {
		this.financialStatus = financialStatus;
	}

	private String studentName;
    private String studentEmail;
    private String courseTitle;
    private String financialStatus;

    public StudentCourseReportDTO(String studentName, String studentEmail, String courseTitle, Enrollment.EnrollmentStatus status) {
        this.studentName = studentName;
        this.studentEmail = studentEmail;
        this.courseTitle = courseTitle;
        this.financialStatus = status.toString(); // or store directly as EnrollmentStatus
    }


    // getters and setters
}
