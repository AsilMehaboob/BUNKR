// services/tracking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bunkr/services/auth_service.dart';
import 'package:bunkr/models/track_attendance.dart';
import 'package:bunkr/services/config_service.dart';
import 'package:bunkr/services/profile_service.dart';
import 'package:flutter/foundation.dart';

class TrackingService {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();
  final String _baseUrl = ConfigService.supabaseBaseUrl;


Future<List<TrackAttendance>> fetchTrackingData() async {
  final token = await _authService.getToken();
  final profile = await _profileService.fetchProfile();
  final username = profile['username'];

  final response = await http.post(
    Uri.parse('$_baseUrl/fetch-tracking-data'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode({'username': username}),
  );

  // 🔍 Log the full HTTP response
  debugPrint('--- Fetch Tracking Data ---');
  debugPrint('Status Code: ${response.statusCode}');
  debugPrint('Response Body: ${response.body}');
  debugPrint('---------------------------');

  if (response.statusCode == 200) {
    final Map<String, dynamic> decoded = json.decode(response.body);
    final List<dynamic> data = decoded['data'];
    return data.map((item) => TrackAttendance.fromJson(item)).toList();
  }

  throw Exception('Failed to load tracking data');
}

  Future<int> fetchTrackingCount() async {
    final token = await _authService.getToken();
    final profile = await _profileService.fetchProfile();
    final username = profile['username'];

    final response = await http.post(
      Uri.parse('$_baseUrl/fetch-count'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': username}),
    );
  
    if (response.statusCode == 200) {
      return json.decode(response.body)['remaining'];
    }
    throw Exception('Failed to load tracking count');
  }

  Future<void> deleteTrackingRecord(
    String session,
    String course,
    DateTime date,
  ) async {
    final token = await _authService.getToken();
    final profile = await _profileService.fetchProfile();
    final username = profile['username'];

    await http.post(
      Uri.parse('$_baseUrl/delete-tracking-data'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'session': session,
        'course': course,
        'date': date.toIso8601String(),
      }),
    );
  }

  Future<void> deleteAllTrackingRecords() async {
    final token = await _authService.getToken();
    final profile = await _profileService.fetchProfile();
    final username = profile['username'];

    await http.post(
      Uri.parse('$_baseUrl/delete-records-of-users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': username}),
    );
  }
}