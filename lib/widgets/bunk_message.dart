import 'package:flutter/material.dart';
import '../models/course_attendance.dart';

class BunkMessage extends StatelessWidget {
  final CourseAttendance attendance;

  const BunkMessage({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final present = attendance.present;
    final total = attendance.total;
    final percentage = attendance.percentage;

    String message;
    Color color;

    if (percentage < 75) {
      final required = (3 * total - 4 * present).clamp(0, double.infinity).toInt();
      message = 'Attend $required more to reach 75%';
      color = Colors.red[400]!;
    } else if (percentage > 75) {
      final bunkable = ((4 * present - 3 * total) ~/ 3).clamp(0, double.infinity).toInt();
      message = 'Can bunk $bunkable safely';
      color = Colors.green[400]!;
    } else {
      message = 'Perfect 75% attendance';
      color = Colors.grey;
    }

    return Text(
      message,
      style: TextStyle(
        color: color,
        fontSize: 9,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}