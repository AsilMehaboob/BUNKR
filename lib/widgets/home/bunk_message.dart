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

    List<InlineSpan> textSpans;
    Color color;

    if (attendancePercentage < targetPercentage / 100.0) {
      final requiredNumerator = targetPercentage * total - 100 * present;
      final requiredDenominator = 100 - targetPercentage;
      final int required = (requiredNumerator / requiredDenominator).ceil().clamp(0, double.infinity).toInt();

      color = Colors.orange;
      textSpans = [
        const TextSpan(text: 'You need to attend ', style: TextStyle(color: Colors.white)),
        TextSpan(text: required.toString(), style: TextStyle(color: color)),
        const TextSpan(text: ' more classes ', style: TextStyle(color: Colors.white)),
      ];
    } else if (attendancePercentage > targetPercentage / 100.0) {
      final bunkableNumerator = 100 * present - targetPercentage * total;
      final bunkableDenominator = targetPercentage;
      final int bunkable = (bunkableNumerator ~/ bunkableDenominator).clamp(0, double.infinity).toInt();

      color = Colors.green[400]!;
      textSpans = [
        const TextSpan(text: 'You can bunk up to ', style: TextStyle(color: Colors.white)),
        TextSpan(text: bunkable.toString(), style: TextStyle(color: color)),
        const TextSpan(text: ' periods', style: TextStyle(color: Colors.white)),
      ];
    } else {
      color = Colors.grey;
      textSpans = [
        const TextSpan(text: 'Perfect ', style: TextStyle(color: Colors.white)),
        TextSpan(text: targetPercentage.toString(), style: TextStyle(color: color)),
        const TextSpan(text: '% attendance', style: TextStyle(color: Colors.white)),
      ];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            children: textSpans,
          ),
        ),
      ),
    );
  }
}