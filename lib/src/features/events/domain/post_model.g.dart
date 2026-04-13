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
      startdateTime: const TimestampConverter().fromJson(json['startdateTime']),
      entdateTime: const TimestampConverter().fromJson(json['entdateTime']),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      image: json['image'] as String? ?? '',
      emailuser: json['emailuser'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      postbyname: json['postbyname'] as String? ?? '',
      postbyimage: json['postbyimage'] as String? ?? '',
      numpeople: json['Numpeople'] as String? ?? '',
      agerange: json['agerange'] as String? ?? '',
    );

Map<String, dynamic> _$$PostModelImplToJson(
  _$PostModelImpl instance,
) => <String, dynamic>{
  'postid': instance.postid,
  'uid': instance.uid,
  'name': instance.name,
  'place': instance.place,
  'startdateTime': const TimestampConverter().toJson(instance.startdateTime),
  'entdateTime': const TimestampConverter().toJson(instance.entdateTime),
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'image': instance.image,
  'emailuser': instance.emailuser,
  'address': instance.address,
  'description': instance.description,
  'category': instance.category,
  'gender': instance.gender,
  'postbyname': instance.postbyname,
  'postbyimage': instance.postbyimage,
  'Numpeople': instance.numpeople,
  'agerange': instance.agerange,
};
