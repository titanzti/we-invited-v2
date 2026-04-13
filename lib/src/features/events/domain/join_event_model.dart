import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../utils/timestamp_converter.dart';

part 'join_event_model.freezed.dart';
part 'join_event_model.g.dart';

@freezed
class JoinEventModel with _$JoinEventModel {
  const factory JoinEventModel({
    required String joinid,
    required String postid,
    @Default('') String ownerID,
    @Default('') String ownerName,
    @Default('') String senderAvatar,
    @Default('') String senderName,
    @Default('') String senderUid,
    @Default('') String receiverUidjoin,
    @Default('') String requestpostid,
    @Default('') String senderEmail,
    @Default('') String status,
    @Default('') String type,
    @Default('') String title,
    @TimestampConverter() Timestamp? createdAt,
  }) = _JoinEventModel;

  factory JoinEventModel.fromJson(Map<String, dynamic> json) => _$JoinEventModelFromJson(json);
}
