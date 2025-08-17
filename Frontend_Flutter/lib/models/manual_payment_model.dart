class ManualPaymentModel {
  final int? id;
  final String method;
  final String transactionId;
  final String sender;
  final String email;
  final String status;
  final DateTime submittedAt;

  // Optional display fields
  final String? courseTitle; // For receipt or UI display
  final double? amount; // Course price

  ManualPaymentModel({
    this.id,
    required this.method,
    required this.transactionId,
    required this.sender,
    required this.email,
    this.status = "PENDING",
    DateTime? submittedAt,
    this.courseTitle,
    this.amount,
  }) : submittedAt = submittedAt ?? DateTime.now();

  factory ManualPaymentModel.fromJson(Map<String, dynamic> json) =>
      ManualPaymentModel(
        id: json['id'],
        method: json['method'],
        transactionId: json['transactionId'],
        sender: json['sender'],
        email: json['email'],
        status: json['status'] ?? "PENDING",
        submittedAt: json['submittedAt'] != null
            ? DateTime.parse(json['submittedAt'])
            : DateTime.now(),
        courseTitle: json['courseTitle'],
        amount: json['amount'] != null
            ? (json['amount'] as num).toDouble()
            : null,
      );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    "method": method,
    "transactionId": transactionId,
    "sender": sender,
    "email": email,
    "status": status,
    "submittedAt": submittedAt.toIso8601String(),
    if (courseTitle != null) "courseTitle": courseTitle,
    if (amount != null) "amount": amount,
  };
}
