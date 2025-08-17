class StudentProfile {
  int? id;
  String name;
  String email;
  int age;
  String course;
  String? imageUrl; // server থেকে আসা image URL

  StudentProfile({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.course,
    this.imageUrl,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) => StudentProfile(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    age: json['age'],
    course: json['course'],
    imageUrl: json['imageUrl'], // backend থেকে আসবে
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "age": age,
    "course": course,
  };
}
