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
