import 'package:dio/dio.dart';

sealed class AppException implements Exception {
  final String message;
  final String code;

  const AppException(this.message, this.code);

  @override
  String toString() => message;

  static AppException fromDio(dynamic e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      
      final serverMsg = switch (data) {
        {'error': final String err} => err,
        {'message': final String msg} => msg,
        _ => null,
      };

      return switch (statusCode) {
        400 => BadRequestException(serverMsg ?? 'Invalid request. Please check your input.'),
        401 => const UnauthorizedException('Session expired. Please sign in again.'),
        403 => const ForbiddenException('You don\'t have permission to do this.'),
        404 => const NotFoundException('The requested resource was not found.'),
        409 => ConflictException(serverMsg ?? 'This action conflicts with existing data.'),
        422 => ValidationException(serverMsg ?? 'Please check your input and try again.'),
        429 => const RateLimitException('Too many requests. Please wait a moment.'),
        final int code when code >= 500 => const ServerException('Server error. Please try again later.'),
        _ => UnknownException(serverMsg ?? 'Something went wrong. Please try again.'),
      };
    }

    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
        return const NetworkException('No internet connection. Please check your network.');
      }
    }

    return const UnknownException('An unexpected error occurred. Please try again.');
  }
}

final class BadRequestException extends AppException {
  const BadRequestException(String message) : super(message, 'bad_request');
}
final class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message, 'unauthorized');
}
final class ForbiddenException extends AppException {
  const ForbiddenException(String message) : super(message, 'forbidden');
}
final class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message, 'not_found');
}
final class ConflictException extends AppException {
  const ConflictException(String message) : super(message, 'conflict');
}
final class ValidationException extends AppException {
  const ValidationException(String message) : super(message, 'validation');
}
final class RateLimitException extends AppException {
  const RateLimitException(String message) : super(message, 'rate_limit');
}
final class ServerException extends AppException {
  const ServerException(String message) : super(message, 'server_error');
}
final class NetworkException extends AppException {
  const NetworkException(String message) : super(message, 'network');
}
final class UnknownException extends AppException {
  const UnknownException(String message) : super(message, 'unknown_error');
}
