import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<Timestamp?, dynamic> {
  const TimestampConverter();

  @override
  Timestamp? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json;
    
    // Sometimes Firestore returns an object with _seconds and _nanoseconds when decoded from JSON
    if (json is Map<String, dynamic>) {
      if (json.containsKey('_seconds') && json.containsKey('_nanoseconds')) {
        return Timestamp(json['_seconds'] as int, json['_nanoseconds'] as int);
      }
      if (json.containsKey('seconds') && json.containsKey('nanoseconds')) {
        return Timestamp(json['seconds'] as int, json['nanoseconds'] as int);
      }
    }
    
    // In some edge cases Firebase might convert it to a string dates
    if (json is String) {
      return Timestamp.fromDate(DateTime.tryParse(json) ?? DateTime.now());
    }

    if (json is int) {
      return Timestamp.fromMillisecondsSinceEpoch(json);
    }
    
    return null;
  }

  @override
  dynamic toJson(Timestamp? object) {
    if (object == null) return null;
    // For Firestore persistence, we just return the object.
    // If you're building a strict JSON API, you might return `.toIso8601String()` here.
    return object;
  }
}
