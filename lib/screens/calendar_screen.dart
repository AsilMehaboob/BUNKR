import 'package:flutter/material.dart';
import '../widgets/calendar/calendar.dart';
import '../widgets/appbar/app_bar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black, // Set background to black
      body:  Center(
        child: CalendarPage(),
      ),
    );
  }
}