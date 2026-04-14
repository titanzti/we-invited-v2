class InviteModel {
  final String id;
  final String eventId;
  final String inviterId;
  final String inviteeId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final InviteUserModel? invitee;
  final InviteUserModel? inviter;
  final InviteEventModel? event;

  InviteModel({
    required this.id,
    required this.eventId,
    required this.inviterId,
    required this.inviteeId,
    this.status = 'PENDING',
    this.createdAt,
    this.updatedAt,
    this.invitee,
    this.inviter,
    this.event,
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) => InviteModel(
        id: json["id"] ?? '',
        eventId: json["eventId"] ?? '',
        inviterId: json["inviterId"] ?? '',
        inviteeId: json["inviteeId"] ?? '',
        status: json["status"] ?? 'PENDING',
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"].toString()),
        invitee: json["invitee"] == null
            ? null
            : InviteUserModel.fromJson(json["invitee"]),
        inviter: json["inviter"] == null
            ? null
            : InviteUserModel.fromJson(json["inviter"]),
        event: json["event"] == null
            ? null
            : InviteEventModel.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventId": eventId,
        "inviterId": inviterId,
        "inviteeId": inviteeId,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "invitee": invitee?.toJson(),
        "inviter": inviter?.toJson(),
        "event": event?.toJson(),
      };
}

class InviteUserModel {
  final String id;
  final String name;
  final String email;
  final String? image;

  InviteUserModel({
    required this.id,
    this.name = '',
    this.email = '',
    this.image,
  });

  factory InviteUserModel.fromJson(Map<String, dynamic> json) =>
      InviteUserModel(
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

class InviteEventModel {
  final String id;
  final String title;
  final DateTime? startDate;
  final InviteCreatorModel? creator;

  InviteEventModel({
    required this.id,
    this.title = '',
    this.startDate,
    this.creator,
  });

  factory InviteEventModel.fromJson(Map<String, dynamic> json) =>
      InviteEventModel(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
        startDate: json["startDate"] == null
            ? null
            : DateTime.tryParse(json["startDate"].toString()),
        creator: json["creator"] == null
            ? null
            : InviteCreatorModel.fromJson(json["creator"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "startDate": startDate?.toIso8601String(),
        "creator": creator?.toJson(),
      };
}

class InviteCreatorModel {
  final String name;
  final String email;
  final String? image;

  InviteCreatorModel({
    this.name = '',
    this.email = '',
    this.image,
  });

  factory InviteCreatorModel.fromJson(Map<String, dynamic> json) =>
      InviteCreatorModel(
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "image": image,
      };
}
