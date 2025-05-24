import 'package:flutter/material.dart';
import '../models/course_attendance.dart';

class BunkMessage extends StatelessWidget {
  final CourseAttendance attendance;
  final int targetPercentage; // Add this line

  const BunkMessage({
    super.key,
    required this.attendance,
    required this.targetPercentage, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    final present = attendance.present;
    final total = attendance.total;
    final attendancePercentage = attendance.percentage;

    String message;
    Color color;

    if (attendancePercentage < targetPercentage) {
      final requiredNumerator = targetPercentage * total - 100 * present;
      final requiredDenominator = 100 - targetPercentage;
      final required = (requiredNumerator / requiredDenominator).ceil().clamp(0, double.infinity).toInt();
      message = 'Attend $required more to reach $targetPercentage%';
      color = Colors.red[400]!;
    } else if (attendancePercentage > targetPercentage) {
      final bunkableNumerator = 100 * present - targetPercentage * total;
      final bunkableDenominator = targetPercentage;
      final bunkable = (bunkableNumerator ~/ bunkableDenominator).clamp(0, double.infinity).toInt();
      message = 'Can bunk $bunkable safely';
      color = Colors.green[400]!;
    } else {
      message = 'Perfect $targetPercentage% attendance';
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