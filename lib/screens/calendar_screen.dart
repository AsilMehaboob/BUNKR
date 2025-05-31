import 'package:bunkr/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/home/container.dart';

/// Screen for displaying the calendar.
class CalendarScreen extends StatelessWidget {
  /// Creates a [CalendarScreen] widget.
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: CourseCard(),
      ),
    );
  }
}