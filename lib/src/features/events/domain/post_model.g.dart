// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      postid: json['postid'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      startdateTime: const DateTimeConverter().fromJson(json['startdateTime']),
      entdateTime: const DateTimeConverter().fromJson(json['entdateTime']),
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const DateTimeConverter().fromJson(json['updatedAt']),
      image: json['image'] as String? ?? '',
      emailuser: json['emailuser'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      postbyname: json['postbyname'] as String? ?? '',
      postbyimage: json['postbyimage'] as String? ?? '',
      numpeople: json['numpeople'] as String? ?? '',
      agerange: json['agerange'] as String? ?? '',
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'postid': instance.postid,
      'uid': instance.uid,
      'name': instance.name,
      'place': instance.place,
      'startdateTime': const DateTimeConverter().toJson(instance.startdateTime),
      'entdateTime': const DateTimeConverter().toJson(instance.entdateTime),
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
      'image': instance.image,
      'emailuser': instance.emailuser,
      'address': instance.address,
      'description': instance.description,
      'category': instance.category,
      'gender': instance.gender,
      'postbyname': instance.postbyname,
      'postbyimage': instance.postbyimage,
      'numpeople': instance.numpeople,
      'agerange': instance.agerange,
      'requiresApproval': instance.requiresApproval,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
