import 'package:dio/dio.dart';
import 'auth_service.dart';
import 'config_service.dart';

class SupabaseService {
  final AuthService _authService;
  late Dio _dio;
  final String _baseUrl = ConfigService.supabaseBaseUrl;

  SupabaseService(this._authService) {
    _dio = _authService.client;
  }

  Future<Map<String, dynamic>> fetchUserData(Map<String, dynamic> requestBody) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Authentication token is null!');
      }

      final response = await _dio.post(
        '$_baseUrl/fetch-user-data',
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Failed to fetch user data: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}