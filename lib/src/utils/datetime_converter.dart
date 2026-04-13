import 'package:freezed_annotation/freezed_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is DateTime) return json;

    if (json is String) {
      return DateTime.tryParse(json);
    }

    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }

    if (json is Map<String, dynamic>) {
      if (json.containsKey('_seconds')) {
        return DateTime.fromMillisecondsSinceEpoch(
          (json['_seconds'] as int) * 1000,
        );
      }
    }

    return null;
  }

  @override
  dynamic toJson(DateTime? object) {
    return object?.toIso8601String();
  }
}
