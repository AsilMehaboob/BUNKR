import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/course_attendance.dart';
import 'stat_block.dart';
import 'bunk_message.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final CourseAttendance? attendance;
    final int targetPercentage;

  const CourseCard({
    super.key,
    required this.course,
    this.attendance,
    required this.targetPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (attendance?.percentage ?? 0) / 100;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  course.code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${course.academicYear} • ${course.semester}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 9,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Text(
            course.name.toLowerCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          if (attendance != null) ...[
            const SizedBox(height: 6),
            
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatBlock(
                    label: 'Present',
                    value: attendance!.present.toString(),
                    color: Colors.green,
                  ),
                  StatBlock(
                    label: 'Absent',
                    value: attendance!.absent.toString(),
                    color: Colors.red,
                  ),
                  StatBlock(
                    label: 'Total',
                    value: attendance!.total.toString(),
                    color: Colors.grey,
                  ),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
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
                const SizedBox(height: 2),
                BunkMessage(attendance: attendance!,targetPercentage: targetPercentage,),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    const Text(
                      'No attendance data',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
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
}