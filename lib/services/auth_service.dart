// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://production.api.ezygo.app/api/v1',
          contentType: 'application/json; charset=UTF-8',
          responseType: ResponseType.json,
          validateStatus: (status) => status != null && status < 600,
          headers: {
            'Accept': 'application/json, text/plain, */*',
            // Removed 'Origin' and 'Referer' as they are unsafe headers
          },
        ))
          ..interceptors.add(
            LogInterceptor(
              requestHeader: true,
              requestBody: true,
              responseHeader: true,
              responseBody: true,
              logPrint: (obj) => print(obj),
            ),
          );

  /// Attempts login with given credentials.
  /// Returns true on HTTP 200 and stores the returned token; false otherwise.
  Future<bool> login({
    required String username,
    required String password,
    bool stayLoggedIn = false,
  }) async {
    final payload = {
      'username': username,
      'password': password,
      'stay_logged_in': stayLoggedIn,
    };

    try {
      final response = await _dio.post('/Xcr45_salt/login', data: payload);

      print('→ Status: ${response.statusCode}');
      print('→ Body:   ${response.data}');

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final token = response.data['access_token'] as String;
        await _storage.write(key: 'auth_token', value: token);
        return true;
      }
    } on DioException catch (e) {
      print('⚠️ DioException caught: ${e.message}');
      if (e.response != null) {
        print('   • response.statusCode = ${e.response?.statusCode}');
        print('   • response.data       = ${e.response?.data}');
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
    }
    return false;
  }

  /// Retrieves the stored auth token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Clears the stored auth token (logout)
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}