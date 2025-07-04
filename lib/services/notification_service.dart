import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class NotificationService {
  final Dio _dio = AuthService().client;
  final _supabase = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://qsjknoryykjilolbhxos.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzamtub3J5eWtqaWxvbGJoeG9zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY1MDE2MjksImV4cCI6MjA2MjA3NzYyOX0.DrW_C9qO8MWU9koS2GjwVqi7q8ZStUUJag-9uMo-WcI',
    );
  }

  Future<List<Map<String, dynamic>>> getLocalNotifications() async {
    try {
      final response = await _supabase
          .from('notification')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching local notifications from Supabase: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final response = await _dio.get('/user/notifications');
      List<Map<String, dynamic>> apiNotifications = [];

      if (response.statusCode == 200) {
        apiNotifications = List<Map<String, dynamic>>.from(response.data);
      }

      final localNotifications = await getLocalNotifications();

      final allNotifications = [...apiNotifications, ...localNotifications];

      allNotifications.sort((a, b) {
        final dateA = DateTime.parse(a['created_at']);
        final dateB = DateTime.parse(b['created_at']);
        return dateB.compareTo(dateA);
      });

      return allNotifications;
    } on DioException catch (e) {
      debugPrint('Notification fetch error: ${e.message}');
      return await getLocalNotifications();
    } catch (e) {
      debugPrint('Unexpected notification error: $e');
      return await getLocalNotifications();
    }
  }
}
