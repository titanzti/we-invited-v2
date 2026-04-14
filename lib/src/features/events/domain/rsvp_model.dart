enum RSVPStatus { going, notGoing, maybe }

String rsvpStatusToJson(RSVPStatus status) => switch (status) {
      RSVPStatus.going => 'GOING',
      RSVPStatus.notGoing => 'NOT_GOING',
      RSVPStatus.maybe => 'MAYBE',
    };

RSVPStatus rsvpStatusFromJson(String json) => switch (json.toUpperCase()) {
      'GOING' => RSVPStatus.going,
      'NOT_GOING' => RSVPStatus.notGoing,
      _ => RSVPStatus.maybe,
    };

class RSVPModel {
  final String id;
  final String eventId;
  final String userId;
  final RSVPStatus status;
  final int guestCount;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RSVPUserModel? user;
  final RSVPEventModel? event;

  RSVPModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.status,
    this.guestCount = 0,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.event,
  });

  factory RSVPModel.fromJson(Map<String, dynamic> json) => RSVPModel(
        id: json["id"] ?? '',
        eventId: json["eventId"] ?? '',
        userId: json["userId"] ?? '',
        status: rsvpStatusFromJson(json["status"] ?? 'MAYBE'),
        guestCount: json["guestCount"] ?? 0,
        note: json["note"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"].toString()),
        user: json["user"] == null
            ? null
            : RSVPUserModel.fromJson(json["user"]),
        event: json["event"] == null
            ? null
            : RSVPEventModel.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventId": eventId,
        "userId": userId,
        "status": rsvpStatusToJson(status),
        "guestCount": guestCount,
        "note": note,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "event": event?.toJson(),
      };
}

class RSVPUserModel {
  final String id;
  final String name;
  final String email;
  final String? image;

  RSVPUserModel({
    required this.id,
    this.name = '',
    this.email = '',
    this.image,
  });

  factory RSVPUserModel.fromJson(Map<String, dynamic> json) => RSVPUserModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
      };
}

class RSVPEventModel {
  final String id;
  final String title;
  final DateTime? startDate;

  RSVPEventModel({
    required this.id,
    this.title = '',
    this.startDate,
  });

  factory RSVPEventModel.fromJson(Map<String, dynamic> json) => RSVPEventModel(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
        startDate: json["startDate"] == null
            ? null
            : DateTime.tryParse(json["startDate"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "startDate": startDate?.toIso8601String(),
      };
}

class RSVPStats {
  final int going;
  final int maybe;
  final int notGoing;
  final int totalGuests;
  final int totalResponses;

  const RSVPStats({
    this.going = 0,
    this.maybe = 0,
    this.notGoing = 0,
    this.totalGuests = 0,
    this.totalResponses = 0,
  });

  factory RSVPStats.fromJson(Map<String, dynamic> json) => RSVPStats(
        going: json["going"] ?? 0,
        maybe: json["maybe"] ?? 0,
        notGoing: json["notGoing"] ?? 0,
        totalGuests: json["totalGuests"] ?? 0,
        totalResponses: json["totalResponses"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "going": going,
        "maybe": maybe,
        "notGoing": notGoing,
        "totalGuests": totalGuests,
        "totalResponses": totalResponses,
      };
}
