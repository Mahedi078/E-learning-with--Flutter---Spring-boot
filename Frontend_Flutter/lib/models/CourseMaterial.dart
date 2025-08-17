// class CourseMaterial {
//   final int? id;
//   final String type;
//   final String title;
//   final String url;
//   final int courseId;

//   CourseMaterial({
//     this.id,
//     required this.type,
//     required this.title,
//     required this.url,
//     required this.courseId,
//   });

//   factory CourseMaterial.fromJson(Map<String, dynamic> json) {
//     return CourseMaterial(
//       id: json['id'],
//       type: json['type'],
//       title: json['title'],
//       url: json['url'],
//       courseId: json['course']['id'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'title': title,
//       'url': url,
//       'course': {'id': courseId},
//     };
//   }
// }
class CourseMaterial {
  final int? id;
  final String type;
  final String title;
  final String url;
  final int courseId;

  CourseMaterial({
    this.id,
    required this.type,
    required this.title,
    required this.url,
    required this.courseId,
  });

  factory CourseMaterial.fromJson(Map<String, dynamic> json) => CourseMaterial(
    id: json['id'],
    type: json['type'],
    title: json['title'],
    url: json['url'],
    courseId: json['course']['id'], // ✅ correct mapping
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'url': url,
    'course': {'id': courseId},
  };
}
