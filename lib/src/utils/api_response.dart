/// Standard API envelope model following Dart fromJson/toJson convention.
/// All API responses follow: `{ "data": T, "message": "...", "error": "..." }`
class ApiResponse<T> {
  T? data;
  String? message;
  String? error;

  ApiResponse({
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) =>
      ApiResponse(
        data: json["data"] == null ? null : fromJsonT(json["data"]),
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toJson(dynamic Function(T?) toJsonT) => {
        "data": data == null ? null : toJsonT(data),
        "message": message,
        "error": error,
      };
}
