import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:bunkr/services/auth_service.dart';
import 'package:bunkr/models/track_attendance.dart';
import 'package:bunkr/services/config_service.dart';
import 'package:bunkr/services/user_service.dart';

class TrackingService {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final String _baseUrl = ConfigService.supabaseBaseUrl;
  final Dio _dio = Dio();

  Future<List<TrackAttendance>> fetchTrackingData() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Authentication token is null');
      }

      final profile = await _userService.fetchUserProfile();
      final username = profile['username'] ?? '';
      if (username.isEmpty) {
        throw Exception('Username is empty');
      }

      final requestBody = {'username': username};

      final response = await _dio.post(
        '$_baseUrl/fetch-tracking-data',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: requestBody,
      );

      final decoded = response.data;

      if (decoded is Map && decoded.containsKey('data') && decoded['data'] != null) {
        final List<dynamic> data = decoded['data'];

        final processedData = data.map((item) {
          if (item['date'] != null && item['date'] is String) {
            try {
              final dateParts = item['date'].split('/');
              if (dateParts.length == 3) {
                final month = int.parse(dateParts[0]).toString().padLeft(2, '0');
                final day = int.parse(dateParts[1]).toString().padLeft(2, '0');
                final year = dateParts[2];
                item = {...item, 'date': '$year-$month-$day'};
              }
            } catch (e) {
              debugPrint('Error preprocessing date: ${item['date']} - $e');
            }
          }
          return item;
        }).toList();

        debugPrint('🔍 Processed tracking data: $processedData');

        return processedData.map((item) => TrackAttendance.fromJson(item)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio error: ${e.message}');
      throw Exception('Failed to load tracking data: ${e.response?.statusCode} - ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<int> fetchTrackingCount() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Authentication token is null');
      }

      final profile = await _userService.fetchUserProfile();
      final username = profile['username'] ?? '';
      if (username.isEmpty) {
        throw Exception('Username is empty in profile');
      }

      final requestBody = {'username': username};

      debugPrint('--- Fetch Tracking Count REQUEST ---');
      debugPrint('URL: $_baseUrl/fetch-count');
      debugPrint('Token: ${token.substring(0, 20)}...');
      debugPrint('Request Body: $requestBody');
      debugPrint('------------------------------------');

      final response = await _dio.post(
        '$_baseUrl/fetch-count',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: requestBody,
      );

      debugPrint('--- Fetch Tracking Count RESPONSE ---');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.data}');
      debugPrint('-------------------------------------');

      final decoded = response.data;
      debugPrint('🔍 Count response decoded: $decoded');

      if (decoded is Map && decoded.containsKey('remaining')) {
        return decoded['remaining'] ?? 0;
      } else {
        debugPrint('⚠️ No "remaining" field found, returning 0');
        return 0;
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio error in fetchTrackingCount: ${e.message}');
      throw Exception('Failed to load tracking count: ${e.response?.statusCode} - ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
