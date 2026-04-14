class JoinRequestModel {
  final String id;
  final String eventId;
  final String userId;
  final String name;
  final String email;
  final String status;
  final DateTime? createdAt;

  JoinRequestModel({
    this.id = '',
    this.eventId = '',
    this.userId = '',
    this.name = '',
    this.email = '',
    this.status = 'pending',
    this.createdAt,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) =>
      JoinRequestModel(
        id: json["id"] ?? '',
        eventId: json["eventId"] ?? '',
        userId: json["userId"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        status: json["status"] ?? 'pending',
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventId": eventId,
        "userId": userId,
        "name": name,
        "email": email,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
      };
}
