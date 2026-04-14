// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JoinRequestModelImpl _$$JoinRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$JoinRequestModelImpl(
  id: json['id'] as String? ?? '',
  eventId: json['eventId'] as String? ?? '',
  userId: json['userId'] as String? ?? '',
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  status: json['status'] as String? ?? 'pending',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$JoinRequestModelImplToJson(
  _$JoinRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'userId': instance.userId,
  'name': instance.name,
  'email': instance.email,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
};
