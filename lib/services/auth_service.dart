import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config_service.dart';
import 'dart:io';

class LoginResult {
  final bool success;
  final String message;

  LoginResult({required this.success, required this.message});
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  Map<bool, String> loginResult = {};

  AuthService._internal() {
    _dio = Dio(BaseOptions(
      contentType: 'application/json; charset=UTF-8',
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status < 600,
      headers: {'Accept': 'application/json, text/plain, */*'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> init() async {
    // Set base URL after environment is loaded
    _dio.options.baseUrl = ConfigService.apiBaseUrl;

    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<LoginResult> login({
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
      final response = await _dio.post('/login', data: payload);

      print('→ Status: ${response.statusCode}');
      print('→ Body:   ${response.data}');

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final token = response.data['access_token'] as String;
        await _storage.write(key: 'auth_token', value: token);
        _dio.options.headers['Authorization'] = 'Bearer $token';

        return LoginResult(success: true, message: "Login successful");
      } else {
        String message = "Login failed";

        if (response.statusCode == 401) {
          message = "Invalid username or password";
        } else if (response.statusCode == 403) {
          message = "Access denied";
        } else if (response.statusCode == 500) {
          message = "Server error. Please try again later.";
        } else if (response.data is Map && response.data['message'] != null) {
          message = response.data['message'].toString();
        }

        return LoginResult(success: false, message: message);
      }
    } 
     on DioException catch (e) {
      if(e.error is SocketException) {
        print('SocketException: ${e.error}');
        return LoginResult(success: false, message: "No Internet connection");
      }
      print('⚠️ DioException caught: ${e.message}');
      final msg =
          e.response?.data?['message'] ?? e.message ?? "Something went wrong";
      return LoginResult(success: false, message: msg);
    } catch (e) {
      print('❌ Unexpected error: $e');
      return LoginResult(
          success: false, message: "An unexpected error occurred");
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _dio.options.headers.remove('Authorization');
  }

  Dio get client => _dio;
}
