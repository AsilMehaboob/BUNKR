import 'package:flutter/material.dart'; // ADD THIS IMPORT
import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons/lucide_icons.dart' as lucide; // ADD THIS IMPORT

const notifications = [
  (
    title: "Your call has been confirmed.",
    description: "1 hour ago",
  ),
  (
    title: "You have a new message!",
    description: "1 hour ago",
  ),
  (
    title: "Your subscription is expiring soon!",
    description: "2 hours ago",
  ),
];

class CardNotifications extends StatefulWidget {
  const CardNotifications({super.key});

  @override
  State<CardNotifications> createState() => _CardNotificationsState();
}

class _CardNotificationsState extends State<CardNotifications> {
  final pushNotifications = ValueNotifier<bool>(false); // FIXED: Added type parameter

  @override
  void dispose() {
    pushNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadCard(
      title: const Text('Notifications'),
      description: const Text('You have 3 unread messages.'),
      border: Border.fromBorderSide(BorderSide.none),
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: theme.radius,
              border: Border.all(color: theme.colorScheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  lucide.LucideIcons.bellRing,
                  size: 24,
                  color: theme.colorScheme.foreground,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Push Notifications',
                          style: theme.textTheme.small,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Send notifications to device.',
                          style: theme.textTheme.muted,
                        )
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: pushNotifications,
                  builder: (context, value, child) {
                    return ShadSwitch(
                      value: value,
                      onChanged: (v) => pushNotifications.value = v,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // FIXED: Convert to list before using separatedBy
          ...notifications
              .map(
                (n) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0CA5E9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FIXED: Use n.title instead of hardcoded text
                            Text(n.title, style: theme.textTheme.small),
                            const SizedBox(height: 4),
                            Text(n.description, style: theme.textTheme.muted),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
              .toList() // Convert to List<Widget>
              .separatedBy(const SizedBox(height: 16)), // Now works
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}