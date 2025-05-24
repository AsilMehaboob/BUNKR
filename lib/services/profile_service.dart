// profile_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';

class ProfileService {
  final AuthService _authService = AuthService();
  final String baseUrl = 'https://production.api.ezygo.app/api/v1/Xcr45_salt';

  Future<Map<String, dynamic>> fetchProfile() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/myprofile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load profile (status ${response.statusCode})');
  }
}