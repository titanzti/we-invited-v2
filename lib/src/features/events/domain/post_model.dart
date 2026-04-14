import '../../../utils/datetime_converter.dart';

const _dt = DateTimeConverter();

class PostModel {
  final String postid;
  final String uid;
  final String name;
  final String place;
  final DateTime? startdateTime;
  final DateTime? entdateTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String image;
  final String emailuser;
  final String address;
  final String description;
  final String category;
  final String gender;
  final String postbyname;
  final String postbyimage;
  final String numpeople;
  final String agerange;
  final bool requiresApproval;
  final double? latitude;
  final double? longitude;

  PostModel({
    required this.postid,
    required this.uid,
    this.name = '',
    this.place = '',
    this.startdateTime,
    this.entdateTime,
    this.createdAt,
    this.updatedAt,
    this.image = '',
    this.emailuser = '',
    this.address = '',
    this.description = '',
    this.category = '',
    this.gender = '',
    this.postbyname = '',
    this.postbyimage = '',
    this.numpeople = '',
    this.agerange = '',
    this.requiresApproval = false,
    this.latitude,
    this.longitude,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        postid: json["postid"] ?? '',
        uid: json["uid"] ?? '',
        name: json["name"] ?? '',
        place: json["place"] ?? '',
        startdateTime: _dt.fromJson(json["startdateTime"]),
        entdateTime: _dt.fromJson(json["entdateTime"]),
        createdAt: _dt.fromJson(json["createdAt"]),
        updatedAt: _dt.fromJson(json["updatedAt"]),
        image: json["image"] ?? '',
        emailuser: json["emailuser"] ?? '',
        address: json["address"] ?? '',
        description: json["description"] ?? '',
        category: json["category"] ?? '',
        gender: json["gender"] ?? '',
        postbyname: json["postbyname"] ?? '',
        postbyimage: json["postbyimage"] ?? '',
        numpeople: json["numpeople"] ?? '',
        agerange: json["agerange"] ?? '',
        requiresApproval: json["requiresApproval"] ?? false,
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "postid": postid,
        "uid": uid,
        "name": name,
        "place": place,
        "startdateTime": _dt.toJson(startdateTime),
        "entdateTime": _dt.toJson(entdateTime),
        "createdAt": _dt.toJson(createdAt),
        "updatedAt": _dt.toJson(updatedAt),
        "image": image,
        "emailuser": emailuser,
        "address": address,
        "description": description,
        "category": category,
        "gender": gender,
        "postbyname": postbyname,
        "postbyimage": postbyimage,
        "numpeople": numpeople,
        "agerange": agerange,
        "requiresApproval": requiresApproval,
        "latitude": latitude,
        "longitude": longitude,
      };
}
