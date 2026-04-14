import 'package:freezed_annotation/freezed_annotation.dart';

part 'rsvp_model.freezed.dart';
part 'rsvp_model.g.dart';

@freezed
class RSVPModel with _$RSVPModel {
  const factory RSVPModel({
    required String id,
    required String eventId,
    required String userId,
    @RSVPStatusConverter() required RSVPStatus status,
    @Default(0) int guestCount,
    String? note,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    RSVPUserModel? user,
    RSVPEventModel? event,
  }) = _RSVPModel;

  factory RSVPModel.fromJson(Map<String, dynamic> json) =>
      _$RSVPModelFromJson(json);
}

@freezed
class RSVPUserModel with _$RSVPUserModel {
  const factory RSVPUserModel({
    required String id,
    required String name,
    required String email,
    String? image,
  }) = _RSVPUserModel;

  factory RSVPUserModel.fromJson(Map<String, dynamic> json) =>
      _$RSVPUserModelFromJson(json);
}

@freezed
class RSVPEventModel with _$RSVPEventModel {
  const factory RSVPEventModel({
    required String id,
    required String title,
    @JsonKey(name: 'startDate') DateTime? startDate,
  }) = _RSVPEventModel;

  factory RSVPEventModel.fromJson(Map<String, dynamic> json) =>
      _$RSVPEventModelFromJson(json);
}

@freezed
class RSVPStats with _$RSVPStats {
  const factory RSVPStats({
    @Default(0) int going,
    @Default(0) int maybe,
    @Default(0) int notGoing,
    @Default(0) int totalGuests,
    @Default(0) int totalResponses,
  }) = _RSVPStats;

  factory RSVPStats.fromJson(Map<String, dynamic> json) =>
      _$RSVPStatsFromJson(json);
}

enum RSVPStatus {
  @JsonValue('GOING')
  going,
  @JsonValue('NOT_GOING')
  notGoing,
  @JsonValue('MAYBE')
  maybe,
}

class RSVPStatusConverter implements JsonConverter<RSVPStatus, String> {
  const RSVPStatusConverter();

  @override
  RSVPStatus fromJson(String json) {
    return RSVPStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == json.toUpperCase(),
      orElse: () => RSVPStatus.maybe,
    );
  }

  @override
  String toJson(RSVPStatus object) {
    return object.name.toUpperCase();
  }
}
