// user_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import 'config_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  final String baseUrl = ConfigService.apiBaseUrl;

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load user profile (status ${response.statusCode})');
  }
}