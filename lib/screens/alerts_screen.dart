import 'package:bunkr/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/alerts/notifications_card.dart';

/// Screen for displaying the calendar.
class AlertsScreen extends StatelessWidget {
  /// Creates a [CalendarScreen] widget.
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: CardNotifications(),
      ),
    );
  }
}