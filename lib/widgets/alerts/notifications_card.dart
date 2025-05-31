import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../services/notification_service.dart';

class CardNotifications extends StatefulWidget {
  const CardNotifications({super.key});

  @override
  State<CardNotifications> createState() => _CardNotificationsState();
}

class _CardNotificationsState extends State<CardNotifications> {
  final pushNotifications = ValueNotifier<bool>(false);
  final NotificationService _notificationService = NotificationService();
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationService.fetchNotifications();
  }

  @override
  void dispose() {
    pushNotifications.dispose();
    super.dispose();
  }

  String _formatTimeAgo(String isoDate) {
    final date = DateTime.parse(isoDate);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  // Extract only the main message from notification data
  String _extractMessage(String data) {
    // Find the index where the device info starts
    final deviceInfoIndex = data.indexOf('Date:');
    if (deviceInfoIndex != -1) {
      // Return only the part before device info
      return data.substring(0, deviceInfoIndex).trim();
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadCard(
      title: const Text('Notifications'),
      description: FutureBuilder(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          final count = snapshot.hasData ? snapshot.data!.length : 0;
          return Text('You have $count unread messages.');
        },
      ),
      border: Border.fromBorderSide(BorderSide.none),
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Scrollable notifications section
          Expanded(
            child: FutureBuilder(
              future: _notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No notifications found'),
                    ),
                  );
                }
                
                final notifications = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    return InkWell(
                      onTap: () => _notificationService.markAsRead(n['id']),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: n['read_at'] == null 
                                  ? const Color(0xFF0CA5E9) 
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
                                    // Extract only the main message
                                    _extractMessage(n['data']),
                                    style: theme.textTheme.small,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimeAgo(n['created_at']),
                                    style: theme.textTheme.muted,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}