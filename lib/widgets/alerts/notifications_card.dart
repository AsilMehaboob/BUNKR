import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/notification_service.dart';

class CardNotifications extends StatefulWidget {
  const CardNotifications({super.key});

  @override
  State<CardNotifications> createState() => _CardNotificationsState();
}

class _CardNotificationsState extends State<CardNotifications> {
  final pushNotifications = ValueNotifier<bool>(false);
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadInitialNotifications();

    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _refreshNotifications();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    pushNotifications.dispose();
    super.dispose();
  }

  Future<void> _loadInitialNotifications({bool isRefreshing = false}) async {
    if (!isRefreshing) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final notifications = await _notificationService.fetchNotifications();

      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshNotifications() async {
    try {
      final freshNotifications =
          await _notificationService.fetchNotifications();

      if (mounted &&
          _notNotificationsEqual(_notifications, freshNotifications)) {
        setState(() {
          _notifications = freshNotifications;
        });
      }
    } catch (e) {
      print('Error refreshing notifications: $e');
    }
  }

  bool _notNotificationsEqual(
      List<Map<String, dynamic>> current, List<Map<String, dynamic>> fresh) {
    if (current.length != fresh.length) return true;

    for (int i = 0; i < current.length; i++) {
      if (current[i]['id'] != fresh[i]['id'] ||
          current[i]['read_at'] != fresh[i]['read_at']) {
        return true;
      }
    }

    return false;
  }

  String _formatTimeAgo(String? isoDate) {
    if (isoDate == null) return 'Unknown time';

    final date = DateTime.parse(isoDate);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    }
    return 'Just now';
  }

  String _extractMessage(dynamic data) {
    if (data == null) return 'No message content';

    if (data is String) {
      final deviceInfoIndex = data.indexOf('Date:');
      if (deviceInfoIndex != -1) {
        return data.substring(0, deviceInfoIndex).trim();
      }
      return data;
    }

    return data.toString();
  }

  String _getNotificationContent(Map<String, dynamic> notification) {
    if (notification['data'] != null) {
      return _extractMessage(notification['data']);
    }

    if (notification['description'] != null) {
      return notification['description'];
    }

    if (notification['title'] != null) {
      return notification['title'];
    }

    return 'No message content';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildNotificationContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.blue[300],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No notifications found',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadInitialNotifications(isRefreshing: true),
      color: Colors.white,
      backgroundColor: Colors.black,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 14,
          color: const Color.fromARGB(133, 36, 36, 36),
        ),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: n['read_at'] == null
                        ? Colors.blue[400]
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getNotificationContent(n),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 34, 33, 33),
                                width: 1,
                              ),
                              color: const Color.fromARGB(255, 16, 16, 16),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              _formatTimeAgo(n['created_at']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                          if (n['topic'] != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 34, 33, 33),
                                    width: 1,
                                  ),
                                  color: const Color.fromARGB(255, 28, 28, 28),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  n['topic'] ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.blue[300],
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
