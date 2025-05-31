import 'package:flutter/material.dart';
import '../../models/course_attendance.dart';

class BunkMessage extends StatelessWidget {
  final CourseAttendance attendance;
  final int targetPercentage;

  const BunkMessage({
    super.key,
    required this.attendance,
    required this.targetPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final int present = attendance.present;
    final int total = attendance.total;
    final double attendancePercentage = attendance.percentage;

    String message;
    Color color;

    if (attendancePercentage < targetPercentage / 100.0) {
      final requiredNumerator = targetPercentage * total - 100 * present;
      final requiredDenominator = 100 - targetPercentage;
      final int required = (requiredNumerator / requiredDenominator).ceil().clamp(0, double.infinity).toInt();

      message = 'Attend $required more to reach $targetPercentage%';
      color = Colors.red[400]!;
    } else if (attendancePercentage > targetPercentage / 100.0) {
      final bunkableNumerator = 100 * present - targetPercentage * total;
      final bunkableDenominator = targetPercentage;
      final int bunkable = (bunkableNumerator ~/ bunkableDenominator).clamp(0, double.infinity).toInt();

      message = 'You can bunk up to $bunkable periods';
      color = Colors.green[400]!;
    } else {
      message = 'Perfect $targetPercentage% attendance';
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
