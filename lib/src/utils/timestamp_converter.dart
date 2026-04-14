import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter {
  const TimestampConverter();

  Timestamp? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json;
    
    if (json is Map<String, dynamic>) {
      if (json.containsKey('_seconds') && json.containsKey('_nanoseconds')) {
        return Timestamp(json['_seconds'] as int, json['_nanoseconds'] as int);
      }
      if (json.containsKey('seconds') && json.containsKey('nanoseconds')) {
        return Timestamp(json['seconds'] as int, json['nanoseconds'] as int);
      }
    }
    
    if (json is String) {
      return Timestamp.fromDate(DateTime.tryParse(json) ?? DateTime.now());
    }

    if (json is int) {
      return Timestamp.fromMillisecondsSinceEpoch(json);
    }
    
    return null;
  }

  dynamic toJson(Timestamp? object) {
    if (object == null) return null;
    return object;
  }
}
