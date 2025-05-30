import 'package:flutter/material.dart';

/// Screen for displaying the calendar.
class CalendarScreen extends StatelessWidget {
  /// Creates a [CalendarScreen] widget.
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Calendar Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}