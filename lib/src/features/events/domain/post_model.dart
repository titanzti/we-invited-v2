import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../utils/timestamp_converter.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String postid,
    required String uid,
    @Default('') String name,
    @Default('') String place,
    @TimestampConverter() Timestamp? startdateTime,
    @TimestampConverter() Timestamp? entdateTime,
    @TimestampConverter() Timestamp? createdAt,
    @TimestampConverter() Timestamp? updatedAt,
    @Default('') String image,
    @Default('') String emailuser,
    @Default('') String address,
    @Default('') String description,
    @Default('') String category,
    @Default('') String gender,
    @Default('') String postbyname,
    @Default('') String postbyimage,
    @JsonKey(name: 'Numpeople') @Default('') String numpeople,
    @Default('') String agerange,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}
