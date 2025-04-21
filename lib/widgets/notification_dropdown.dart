import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDropdown extends StatelessWidget {
  final int unreadCount;
  final List<dynamic> notifications;

  const NotificationDropdown({
    required this.unreadCount,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: _NotificationContent(
            unreadCount: unreadCount,
            notifications: notifications,
          ),
        ),
      ],
      child: Badge(
        label: Text(unreadCount.toString()),
        isLabelVisible: unreadCount > 0,
        child: const Icon(Icons.notifications_none, color: Colors.white),
      ),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  final int unreadCount;
  final List<dynamic> notifications;

  const _NotificationContent({
    required this.unreadCount,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$unreadCount unread', style: TextStyle(color: Colors.blue.shade800)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (notifications.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                child: Column(
                  children: notifications.map((n) => NotificationItem(
                    title: _parseNotificationTitle(n['data']),
                    subtitle: _parseNotificationSubtitle(n['data']),
                    time: DateTime.parse(n['created_at']),
                  )).toList(),
                ),
              ),
            ),
          if (notifications.isEmpty)
            const Center(child: Text('No new notifications', style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  String _parseNotificationTitle(String data) {
    if (data.contains('logged in')) return 'New login detected';
    return 'System notification';
  }

  String _parseNotificationSubtitle(String data) {
    final deviceMatch = RegExp(r'unknown/unknown/(.*?)/').firstMatch(data);
    return deviceMatch?.group(1) ?? 'Unknown device';
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime time;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.security, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                Text(
                  DateFormat('MMM dd, y • HH:mm').format(time),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}