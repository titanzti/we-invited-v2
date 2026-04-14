import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_event_response.freezed.dart';
part 'join_event_response.g.dart';

@freezed
class JoinEventResponse with _$JoinEventResponse {
  const factory JoinEventResponse({
    @Default('') String status,
  }) = _JoinEventResponse;

  factory JoinEventResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinEventResponseFromJson(json);
}
