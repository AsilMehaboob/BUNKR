// notification_service.dart
import 'package:dio/dio.dart';
import 'auth_service.dart';

class NotificationService {
  final Dio _dio = AuthService().client;

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final response = await _dio.get('/user/notifications');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } on DioException catch (e) {
      print('⚠️ Notification fetch error: ${e.message}');
      return [];
    } catch (e) {
      print('❌ Unexpected notification error: $e');
      return [];
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.patch(
        '/user/notifications/$notificationId/read',
      );
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}