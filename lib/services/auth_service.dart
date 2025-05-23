import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // ✅ Singleton instance
  static final AuthService _instance = AuthService._internal();

  // ✅ Factory constructor
  factory AuthService() => _instance;

  // ✅ Private constructor
  AuthService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://production.api.ezygo.app/api/v1/',
      contentType: 'application/json; charset=UTF-8',
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status < 600,
      headers: {
        'Accept': 'application/json, text/plain, */*',
      },
    ));

    // Add interceptor for token injection
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    // Logging
    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ),
    );
  }

  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Initialize on app startup to apply token
  Future<void> init() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Login and store token
  Future<bool> login({
    required String username,
    required String password,
    bool stayLoggedIn = true,
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
        _dio.options.headers['Authorization'] = 'Bearer $token';
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

  /// Read stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Clear token and logout
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _dio.options.headers.remove('Authorization');
  }

  /// Get Dio instance for custom requests
  Dio get client => _dio;
}
