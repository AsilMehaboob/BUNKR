import 'package:bunkr/widgets/home/bunk_message.dart';
import 'package:bunkr/widgets/home/stat_block.dart';
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../models/course_attendance.dart';

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
    // Calculate attendance percentage (0.0 - 1.0)
    final pct = (attendance?.percentage ?? 0) / 100;
    
    // Determine progress bar color based on attendance
    final progressColor = pct >= (targetPercentage / 100) 
        ? Colors.white 
        : Colors.orange;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF181818),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top header section
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                border: Border(bottom: BorderSide(color: Colors.grey.shade800, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    course.name, // Dynamic course name
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      course.code, // Dynamic course code
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stats row
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF181818),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatBlock(
                              label: 'Present',
                              value: attendance?.present.toString() ?? '0',
                              color: Colors.grey, // Consistent color scheme
                            ),
                            StatBlock(
                              label: 'Absent',
                              value: attendance?.absent.toString() ?? '0',
                              color: Colors.grey, // Consistent color scheme
                            ),
                            StatBlock(
                              label: 'Total',
                              value: attendance?.total.toString() ?? '0',
                              color: Colors.grey, // Consistent color scheme
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Attendance progress section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Progress bar with dynamic value and color
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade800,
                            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Attendance labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Attendance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              // Dynamic percentage display
                              '${(pct * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Bunk message with dynamic data
                    BunkMessage(
                      attendance: attendance ?? CourseAttendance(
                        courseId: course.id,
                        code: course.code,
                        name: course.name,
                        present: 0,
                        absent: 0,
                        total: 0,
                        percentage: 0,
                      ),
                      targetPercentage: targetPercentage,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}