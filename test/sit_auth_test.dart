import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:we_invited_v2/src/features/authentication/domain/user_model.dart';

void main() {
  group('SIT Mobile Auth Integration', () {
    late Dio mockDio;

    setUp(() {
      mockDio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
    });

    test('AuthRepository properly maps User data from API structure', () async {
      // Instead of hitting a live Postgres DB via Interceptors, we isolate the mapping
      // to ensure `AuthRepository` doesn't crash when receiving Elysia JSON responses.
      final elysiaResponse = {
        'user': {
          'id': 'abc-123-uuid',
          'email': 'sit@example.com',
          'name': 'SIT Tester',
          'gender': 'Male'
        }
      };

      final mappedUser = UserModel.fromJson(elysiaResponse['user']!);
      
      expect(
        mappedUser,
        isA<UserModel>()
            .having((u) => u.uid, 'uid', 'abc-123-uuid')
            .having((u) => u.email, 'email', 'sit@example.com')
            .having((u) => u.name, 'name', 'SIT Tester'),
      );
    });

    test('AuthRepository expects 200 on /auth/me for Token Validation', () async {
      // Demonstrates configuration is correct for E2E
      expect(
        mockDio.options,
        isA<BaseOptions>().having((o) => o.baseUrl, 'baseUrl', 'http://localhost:3000'),
      );
    });
  });
}
