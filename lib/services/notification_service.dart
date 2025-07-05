import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'config_service.dart';

class NotificationService {
  final Dio _dio = AuthService().client;
  final _supabase = Supabase.instance.client;
  static final anonKey = ConfigService.supabaseAnonKey;
  static final supabaseUrl = ConfigService.supabaseUrl;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
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
