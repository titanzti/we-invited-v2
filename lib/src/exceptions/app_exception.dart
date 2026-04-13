import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String code;

  const AppException(this.message, {this.code = 'unknown_error'});

  @override
  String toString() => message;

  static AppException fromDio(dynamic e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      final serverMsg = data is Map ? data['error'] ?? data['message'] : null;

      return switch (statusCode) {
        400 => AppException(serverMsg ?? 'Invalid request. Please check your input.', code: 'bad_request'),
        401 => const AppException('Session expired. Please sign in again.', code: 'unauthorized'),
        403 => const AppException('You don\'t have permission to do this.', code: 'forbidden'),
        404 => const AppException('The requested resource was not found.', code: 'not_found'),
        409 => AppException(serverMsg ?? 'This action conflicts with existing data.', code: 'conflict'),
        422 => AppException(serverMsg ?? 'Please check your input and try again.', code: 'validation'),
        429 => const AppException('Too many requests. Please wait a moment.', code: 'rate_limit'),
        final code when code != null && code >= 500 => const AppException('Server error. Please try again later.', code: 'server_error'),
        _ => AppException(serverMsg ?? 'Something went wrong. Please try again.', code: 'unknown'),
      };
    }

    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
        return const AppException('No internet connection. Please check your network.', code: 'network');
      }
    }

    return AppException('An unexpected error occurred: $e');
  }
}
