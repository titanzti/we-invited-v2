// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      county: json['county'] as String?,
      age: json['age'] as String?,
      birthday: json['Birthday'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'gender': instance.gender,
      'county': instance.county,
      'age': instance.age,
      'Birthday': instance.birthday,
      'profilePhoto': instance.profilePhoto,
    };
