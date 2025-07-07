import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bunkr/services/auth_service.dart';
import 'package:bunkr/models/track_attendance.dart';
import 'package:bunkr/services/config_service.dart';
import 'package:bunkr/services/user_service.dart';
import 'package:flutter/foundation.dart';

class TrackingService {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final String _baseUrl = ConfigService.supabaseBaseUrl;

Future<List<TrackAttendance>> fetchTrackingData() async {
  try {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('\n\n\n\n ----------------- Authentication token is null!');
    }

    final profile = await _userService.fetchUserProfile();
    final username = profile['username'] ?? '';
    if (username == '') {
      throw Exception('\n\n\n\n ----------------- Username is null!');
    }
    
    final requestBody = json.encode({'username': username});

    final response = await http.post(
      Uri.parse('$_baseUrl/fetch-tracking-data'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> decoded = json.decode(response.body);

      if (decoded.containsKey('data') && decoded['data'] != null) {
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
    }

    throw Exception('Failed to load tracking data: ${response.statusCode} - ${response.body}');
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
      if (username == null) {
        throw Exception('Username is null in profile');
      }

      final requestBody = json.encode({'username': username});
      
      // 🔍 Log the request
      debugPrint('--- Fetch Tracking Count REQUEST ---');
      debugPrint('URL: $_baseUrl/fetch-count');
      debugPrint('Token: ${token.substring(0, 20)}...');
      debugPrint('Request Body: $requestBody');
      debugPrint('------------------------------------');

      final response = await http.post(
        Uri.parse('$_baseUrl/fetch-count'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      // 🔍 Log the HTTP response
      debugPrint('--- Fetch Tracking Count RESPONSE ---');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('-------------------------------------');
    
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        debugPrint('🔍 Count response decoded: $decoded');
        
        if (decoded is Map<dynamic, dynamic> && decoded.containsKey('remaining')) {
          return decoded['remaining'] ?? 0;
        } else {
          debugPrint('⚠️ No remaining field found, returning 0');
          return 0;
        }
      }
      throw Exception('Failed to load tracking count: ${response.statusCode} - ${response.body}');
    } catch (e) {
      debugPrint('❌ Error in fetchTrackingCount: $e');
      rethrow;
    }
  }

  Future<void> deleteTrackingRecord(
    String session,
    String course,
    DateTime date,
  ) async {
    final token = await _authService.getToken();
    final profile = await _userService.fetchUserProfile();
    final username = profile['username'] ?? '';

    final requestBody = json.encode({
      'username': username,
      'session': session,
      'course': course,
      'date': date.toIso8601String(),
    });

    // 🔍 Log the request
    debugPrint('--- Delete Tracking Record REQUEST ---');
    debugPrint('URL: $_baseUrl/delete-tracking-data');
    debugPrint('Token: ${token?.substring(0, 20)}...');
    debugPrint('Request Body: $requestBody');
    debugPrint('--------------------------------------');

    final response = await http.post(
      Uri.parse('$_baseUrl/delete-tracking-data'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );
  }

  Future<void> deleteAllTrackingRecords() async {
    final token = await _authService.getToken();
    final profile = await _userService.fetchUserProfile();
    final username = profile['username'] ?? '';

    final requestBody = json.encode({'username': username});

    final response = await http.post(
      Uri.parse('$_baseUrl/delete-records-of-users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );
  }
}