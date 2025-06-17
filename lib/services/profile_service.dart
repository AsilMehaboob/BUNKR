// services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'config_service.dart';

class ProfileService {
  final AuthService _authService = AuthService();
  final String _baseUrl = ConfigService.apiBaseUrl;

  Future<Map<String, dynamic>> fetchProfile() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/myprofile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load profile: ${response.statusCode}');
  }

  Future<void> updateProfile(int id, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    final response = await http.put(
      Uri.parse('$_baseUrl/userprofiles/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }
}