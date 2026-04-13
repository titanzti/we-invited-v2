import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'id') required String uid,
    String? email,
    String? name,
    String? gender,
    String? county,
    String? age,
    @JsonKey(name: 'Birthday') String? birthday,
    String? profilePhoto,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
