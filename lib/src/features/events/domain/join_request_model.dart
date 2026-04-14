import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_request_model.freezed.dart';
part 'join_request_model.g.dart';

@freezed
class JoinRequestModel with _$JoinRequestModel {
  const factory JoinRequestModel({
    @Default('') String id,
    @Default('') String eventId,
    @Default('') String userId,
    @Default('') String name,
    @Default('') String email,
    @Default('pending') String status,
    DateTime? createdAt,
  }) = _JoinRequestModel;

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) =>
      _$JoinRequestModelFromJson(json);
}
