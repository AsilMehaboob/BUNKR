import 'package:dio/dio.dart';
import 'auth_service.dart';
import 'config_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  final Dio dio = Dio();
  final String baseUrl = ConfigService.apiBaseUrl;

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final token = await _authService.getToken();
    final response = await dio.get(
      '$baseUrl/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    
    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to load user profile (status ${response.statusCode})');
  }
}