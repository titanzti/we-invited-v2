import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../utils/datetime_converter.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String postid,
    required String uid,
    @Default('') String name,
    @Default('') String place,
    @DateTimeConverter() DateTime? startdateTime,
    @DateTimeConverter() DateTime? entdateTime,
    @DateTimeConverter() DateTime? createdAt,
    @DateTimeConverter() DateTime? updatedAt,
    @Default('') String image,
    @Default('') String emailuser,
    @Default('') String address,
    @Default('') String description,
    @Default('') String category,
    @Default('') String gender,
    @Default('') String postbyname,
    @Default('') String postbyimage,
    @Default('') String numpeople,
    @Default('') String agerange,
    @Default(false) bool requiresApproval,
    double? latitude,
    double? longitude,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}
