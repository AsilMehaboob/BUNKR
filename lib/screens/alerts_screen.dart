import 'package:flutter/material.dart';

/// Screen for displaying alerts.
class AlertsScreen extends StatelessWidget {
  /// Creates an [AlertsScreen] widget.
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Alerts Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}