/// Custom Exception to intercept backend errors and translate them contextually
class AppException implements Exception {
  final String message;
  final String code;

  const AppException(this.message, {this.code = 'unknown_error'});

  @override
  String toString() => message;

  /// Helper to convert Firebase strings to readable texts
  static AppException fromFirebase(dynamic e) {
    final errStr = e.toString().toLowerCase();

    if (errStr.contains('user-not-found')) {
      return const AppException('No account found for this email.', code: 'user-not-found');
    }
    if (errStr.contains('wrong-password') || errStr.contains('invalid-credential')) {
      return const AppException('Invalid email or password.', code: 'wrong-password');
    }
    if (errStr.contains('network-request-failed')) {
      return const AppException('No internet connection. Please check your network and try again.', code: 'network');
    }

    return AppException('An unhandled error occurred: $e');
  }
}
