// calendar_screen.dart
import 'package:flutter/material.dart';
import '../widgets/calendar/calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarPage(),
    );
  }
}