import '../../../utils/datetime_converter.dart';

const _dt = DateTimeConverter();

class JoinEventModel {
  final String joinid;
  final String postid;
  final String ownerID;
  final String ownerName;
  final String senderAvatar;
  final String senderName;
  final String senderUid;
  final String receiverUidjoin;
  final String requestpostid;
  final String senderEmail;
  final String status;
  final String type;
  final String title;
  final DateTime? createdAt;

  JoinEventModel({
    required this.joinid,
    required this.postid,
    this.ownerID = '',
    this.ownerName = '',
    this.senderAvatar = '',
    this.senderName = '',
    this.senderUid = '',
    this.receiverUidjoin = '',
    this.requestpostid = '',
    this.senderEmail = '',
    this.status = '',
    this.type = '',
    this.title = '',
    this.createdAt,
  });

  factory JoinEventModel.fromJson(Map<String, dynamic> json) => JoinEventModel(
        joinid: json["joinid"] ?? '',
        postid: json["postid"] ?? '',
        ownerID: json["ownerID"] ?? '',
        ownerName: json["ownerName"] ?? '',
        senderAvatar: json["senderAvatar"] ?? '',
        senderName: json["senderName"] ?? '',
        senderUid: json["senderUid"] ?? '',
        receiverUidjoin: json["receiverUidjoin"] ?? '',
        requestpostid: json["requestpostid"] ?? '',
        senderEmail: json["senderEmail"] ?? '',
        status: json["status"] ?? '',
        type: json["type"] ?? '',
        title: json["title"] ?? '',
        createdAt: _dt.fromJson(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "joinid": joinid,
        "postid": postid,
        "ownerID": ownerID,
        "ownerName": ownerName,
        "senderAvatar": senderAvatar,
        "senderName": senderName,
        "senderUid": senderUid,
        "receiverUidjoin": receiverUidjoin,
        "requestpostid": requestpostid,
        "senderEmail": senderEmail,
        "status": status,
        "type": type,
        "title": title,
        "createdAt": _dt.toJson(createdAt),
      };
}
