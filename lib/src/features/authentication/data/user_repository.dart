import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/user_model.dart';
import '../../../utils/api_client.dart';
import '../../../utils/api_response.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository();
}

class UserRepository {
  UserRepository();

  Future<UserModel?> getProfile() async {
    try {
      final response = await ApiClient.instance.get('/users/profile');
      final result = ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data),
      );
      return result.data;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> updateProfile({
    required String name,
    String? gender,
  }) async {
    try {
      final response = await ApiClient.instance.patch(
        '/users/profile',
        data: {
          'name': name,
          if (gender != null) 'gender': gender,
        },
      );
      final result = ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data),
      );
      return result.data!;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<String> updateProfilePhoto(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();
      final mediaType = switch (extension) {
        'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
        'png' => MediaType('image', 'png'),
        'webp' => MediaType('image', 'webp'),
        _ => MediaType('application', 'octet-stream'),
      };
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: mediaType,
        ),
      });

      final response = await ApiClient.instance.post(
        '/users/avatar',
        data: formData,
      );
      final result = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      final url = result.data?['url'] as String?;
      if (url == null || url.isEmpty) {
        throw Exception('Avatar upload response did not include a URL');
      }
      return url;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }
}
