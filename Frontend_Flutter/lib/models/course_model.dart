class Course {
  int? id;
  String? title;
  String? description;
  int? teacherId;
  int? categoryId;
  String? status;
  double? price;
  String? imageUrl; // নতুন ফিল্ড

  Course({
    this.id,
    this.title,
    this.description,
    this.teacherId,
    this.categoryId,
    this.status,
    this.price,
    this.imageUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      teacherId: json['teacherId'],
      categoryId: json['categoryId'],
      status: json['status'],
      price: (json['price'] as num?)?.toDouble(), // null-safe
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teacherId': teacherId,
      'categoryId': categoryId,
      'status': status,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
