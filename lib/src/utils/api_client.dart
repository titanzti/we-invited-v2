import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiClient {
  static final Dio _dio = Dio();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static String get baseUrl {
    // Handling different localhosts depending on execution environment (Android EMU vs iOS SIM)
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000'; 
  }

  static void initialize() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // JWT Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Automatically fetch and inject the Authorization Bearer Token
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Pass standard exceptions to the globally built AppException bubble up layer
        return handler.next(e);
      },
    ));
  }

  // Singleton Instance provider
  static Dio get instance => _dio;
  
  // Storage Instance provider
  static FlutterSecureStorage get storage => _storage;
}
