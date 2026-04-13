import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../utils/datetime_converter.dart';

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
    @DateTimeConverter() DateTime? createdAt,
  }) = _JoinEventModel;

  factory JoinEventModel.fromJson(Map<String, dynamic> json) => _$JoinEventModelFromJson(json);
}
