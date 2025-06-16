import 'package:flutter/material.dart';
import '../widgets/calendar/calendar_page.dart';
import '../widgets/appbar/app_bar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Klick'
          ),
        ),
        ),
        const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your attendance history at a glance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: CalendarPage(),
          ),
        ),
      ],
      ),
      backgroundColor: Colors.black,
    );
  }
}