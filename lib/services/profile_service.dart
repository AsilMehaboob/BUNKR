import 'package:dio/dio.dart';
import 'dart:convert';
import 'auth_service.dart';
import 'config_service.dart';

class ProfileService {
  final AuthService _authService = AuthService();
  final Dio dio = Dio();
  final String _baseUrl = ConfigService.apiBaseUrl;

  Future<Map<String, dynamic>> fetchProfile() async {
    final token = await _authService.getToken();
    final response = await dio.get(
      '$_baseUrl/myprofile',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to load profile: ${response.statusCode}');
  }

  Future<void> updateProfile(int id, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    final response = await dio.put(
      '$_baseUrl/userprofiles/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
      data: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }
}