class EnrollmentModel {
  final int? id;
  final String name;
  final int age;
  final String dob;
  final String location;
  final String email;
  final String phone;
  final int courseId;
  final String? status;

  EnrollmentModel({
    this.id, // ✅ now optional, not required
    required this.name,
    required this.age,
    required this.dob,
    required this.location,
    required this.email,
    required this.phone,
    required this.courseId,
    this.status,
  });

  // factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
  //   return EnrollmentModel(
  //     id: json['id'], // ✅ Parse ID from response
  //     name: json['name'],
  //     age: json['age'],
  //     dob: json['dob'],
  //     location: json['location'],
  //     email: json['email'],
  //     phone: json['phone'],
  //     courseId: json['course']['id'],
  //     status: json['status'],
  //   );
  // }
  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'],
      name: json['name'],
      age: 0, // backend থেকে age আসে না, তাই dummy
      dob: '', // backend থেকে আসে না
      location: '',
      email: json['email'],
      phone: '',
      courseId: 0, // courseId না এলে default 0
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id, // ✅ Include only if not null (backend may ignore it)
    "name": name,
    "age": age,
    "dob": dob,
    "location": location,
    "email": email,
    "phone": phone,
    "course": {"id": courseId},
    "status": status,
  };
}
