import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track_attendance.dart';

class TrackingService {
  final String _baseUrl;

  TrackingService({required String baseUrl}) : _baseUrl = 'https://qsjknoryykjilolbhxos.supabase.co/functions/v1';

  Future<List<TrackAttendance>> fetchTrackingData(String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/fetch-tracking-data'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      
      // Handle both possible response formats
      if (responseData is Map && responseData['data'] != null) {
        final dataList = responseData['data'] as List;
        return dataList.map((item) => TrackAttendance.fromJson(item)).toList();
      } else if (responseData is List) {
        return responseData.map((item) => TrackAttendance.fromJson(item)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load tracking data: ${response.statusCode}');
    }
  }

  Future<int> fetchTrackingCount(String token, String username) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/fetch-count'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': username}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['remaining'] ?? 0;
    } else {
      throw Exception('Failed to load tracking count: ${response.statusCode}');
    }
  }

  Future<void> addToTracking({
    required String token,
    required TrackAttendance record,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/add-to-tracking'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(record.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to tracking: ${response.statusCode}');
    }
  }

  Future<void> deleteTrackingData({
    required String token,
    required String username,
    required String session,
    required String course,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/delete-tracking-data'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'session': session,
        'course': course,
        'date': date,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete tracking data: ${response.statusCode}');
    }
  }

  Future<void> deleteAllTrackingData({
    required String token,
    required String username,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/delete-records-of-users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': username}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all tracking data: ${response.statusCode}');
    }
  }
}