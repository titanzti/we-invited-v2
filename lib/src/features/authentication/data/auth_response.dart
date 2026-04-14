import '../domain/user_model.dart';

/// Response model for POST /auth/login and POST /auth/register
class AuthResponse {
  String? token;
  UserModel? user;
  String? error;

  AuthResponse({
    this.token,
    this.user,
    this.error,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json["token"],
        user: json["user"] == null
            ? null
            : UserModel.fromJson(json["user"]),
        error: json["error"],
      );
}

/// Response model for GET /auth/me
class AuthMeResponse {
  UserModel? user;

  AuthMeResponse({this.user});

  factory AuthMeResponse.fromJson(Map<String, dynamic> json) => AuthMeResponse(
        user: json["user"] == null
            ? null
            : UserModel.fromJson(json["user"]),
      );
}
