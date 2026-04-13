// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JoinEventModelImpl _$$JoinEventModelImplFromJson(Map<String, dynamic> json) =>
    _$JoinEventModelImpl(
      joinid: json['joinid'] as String,
      postid: json['postid'] as String,
      ownerID: json['ownerID'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      senderAvatar: json['senderAvatar'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      senderUid: json['senderUid'] as String? ?? '',
      receiverUidjoin: json['receiverUidjoin'] as String? ?? '',
      requestpostid: json['requestpostid'] as String? ?? '',
      senderEmail: json['senderEmail'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$JoinEventModelImplToJson(
  _$JoinEventModelImpl instance,
) => <String, dynamic>{
  'joinid': instance.joinid,
  'postid': instance.postid,
  'ownerID': instance.ownerID,
  'ownerName': instance.ownerName,
  'senderAvatar': instance.senderAvatar,
  'senderName': instance.senderName,
  'senderUid': instance.senderUid,
  'receiverUidjoin': instance.receiverUidjoin,
  'requestpostid': instance.requestpostid,
  'senderEmail': instance.senderEmail,
  'status': instance.status,
  'type': instance.type,
  'title': instance.title,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
};
