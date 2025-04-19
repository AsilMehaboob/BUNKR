import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/course_attendance.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final CourseAttendance? attendance;

  const CourseCard({
    Key? key,
    required this.course,
    this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pct = (attendance?.percentage ?? 0) / 100;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  course.code,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              Text(
                '${course.academicYear} • ${course.semester}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 9,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4),
          
          Text(
            course.name.toLowerCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          if (attendance != null) ...[
            SizedBox(height: 6),
            
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statBlock('Present', attendance!.present.toString(), Colors.green),
                  _statBlock('Absent', attendance!.absent.toString(), Colors.red),
                  _statBlock('Total', attendance!.total.toString(), Colors.grey),
                ],
              ),
            ),
            
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'attendance',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${attendance!.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: pct,
                    backgroundColor: Colors.grey[700],
                    valueColor: AlwaysStoppedAnimation(
                      pct >= 0.75 ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                _buildBunkMessage(attendance!),
              ],
            ),
          ] else ...[
            SizedBox(height: 8),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Text(
                      'No attendance data',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Attendance records not updated',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statBlock(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBunkMessage(CourseAttendance attendance) {
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