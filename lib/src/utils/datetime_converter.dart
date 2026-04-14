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
        final rawSeconds = json['_seconds'];
        if (rawSeconds is num) {
          return DateTime.fromMillisecondsSinceEpoch(
            (rawSeconds * 1000).round(),
            isUtc: true,
          );
        }
      }
    }

    return null;
  }

  @override
  dynamic toJson(DateTime? object) {
    return object?.toUtc().toIso8601String();
  }
}
