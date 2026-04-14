// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsvp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RSVPModelImpl _$$RSVPModelImplFromJson(Map<String, dynamic> json) =>
    _$RSVPModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      status: const RSVPStatusConverter().fromJson(json['status'] as String),
      guestCount: (json['guestCount'] as num?)?.toInt() ?? 0,
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : RSVPUserModel.fromJson(json['user'] as Map<String, dynamic>),
      event: json['event'] == null
          ? null
          : RSVPEventModel.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RSVPModelImplToJson(_$RSVPModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'status': const RSVPStatusConverter().toJson(instance.status),
      'guestCount': instance.guestCount,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user,
      'event': instance.event,
    };

_$RSVPUserModelImpl _$$RSVPUserModelImplFromJson(Map<String, dynamic> json) =>
    _$RSVPUserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$RSVPUserModelImplToJson(_$RSVPUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
    };

_$RSVPEventModelImpl _$$RSVPEventModelImplFromJson(Map<String, dynamic> json) =>
    _$RSVPEventModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
    );

Map<String, dynamic> _$$RSVPEventModelImplToJson(
  _$RSVPEventModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'startDate': instance.startDate?.toIso8601String(),
};

_$RSVPStatsImpl _$$RSVPStatsImplFromJson(Map<String, dynamic> json) =>
    _$RSVPStatsImpl(
      going: (json['going'] as num?)?.toInt() ?? 0,
      maybe: (json['maybe'] as num?)?.toInt() ?? 0,
      notGoing: (json['notGoing'] as num?)?.toInt() ?? 0,
      totalGuests: (json['totalGuests'] as num?)?.toInt() ?? 0,
      totalResponses: (json['totalResponses'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RSVPStatsImplToJson(_$RSVPStatsImpl instance) =>
    <String, dynamic>{
      'going': instance.going,
      'maybe': instance.maybe,
      'notGoing': instance.notGoing,
      'totalGuests': instance.totalGuests,
      'totalResponses': instance.totalResponses,
    };
