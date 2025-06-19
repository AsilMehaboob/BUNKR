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

    if (total == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'No classes recorded yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    List<InlineSpan> textSpans = [];
    Color color = Colors.grey;

    if (attendancePercentage < targetPercentage) {
      final requiredNumerator = targetPercentage * total - 100 * present;
      final requiredDenominator = 100 - targetPercentage;
      
      int required = 0;
      if (requiredDenominator > 0) {
        required = (requiredNumerator / requiredDenominator).ceil().clamp(0, double.infinity).toInt();
      } else if (targetPercentage == 100) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'Cannot reach 100% due to past absences',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      color = Colors.orange;
      textSpans = [
        const TextSpan(text: 'You need to attend ', style: TextStyle(color: Colors.white)),
        TextSpan(text: required.toString(), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        TextSpan(text: ' more classes', style: TextStyle(color: Colors.white)),
      ];
    } else if (attendancePercentage > targetPercentage) {
      final bunkableNumerator = 100 * present - targetPercentage * total;
      final bunkableDenominator = targetPercentage;
      
      int bunkable = 0;
      if (bunkableDenominator > 0) {
        bunkable = (bunkableNumerator / bunkableDenominator).floor().clamp(0, double.infinity).toInt();
      } else if (targetPercentage == 0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'You can bunk any number of classes',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      color = Colors.green[400]!;
      textSpans = [
        const TextSpan(text: 'You can bunk up to ', style: TextStyle(color: Colors.white)),
        TextSpan(text: bunkable.toString(), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const TextSpan(text: ' periods', style: TextStyle(color: Colors.white)),
      ];
    } else {
      color = Colors.grey;
      textSpans = [
        const TextSpan(text: 'Perfect ', style: TextStyle(color: Colors.white)),
        TextSpan(text: '$targetPercentage%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const TextSpan(text: ' attendance', style: TextStyle(color: Colors.white)),
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