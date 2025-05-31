import 'package:bunkr/widgets/home/bunk_message.dart';
import 'package:bunkr/widgets/home/stat_block.dart';
import 'package:flutter/material.dart';

import '../../models/course_attendance.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 300, // Increased height to accommodate new elements
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF181818),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top header section (unchanged)
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
                  const Text(
                    "Course Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "CS-101",
                      style: TextStyle(
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
                            StatBlock(label: 'Present', value: '0', color: Colors.grey),
                            StatBlock(label: 'Absent', value: '0', color: Colors.grey),
                            StatBlock(label: 'Total', value: '0', color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    
                    // Attendance progress section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Progress bar with rounded corners
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.75, // Example value (75%)
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade800,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
                              "${(0.75 * 100).toStringAsFixed(0)}%", // Calculated percentage
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
                    BunkMessage(
                      attendance: CourseAttendance(
                        courseId: '1',
                        code: 'CS-101',
                        name: 'Course Name',
                        present: 15,
                        absent: 5,
                        total: 20,
                        percentage: 0.65,
                      ), // Provide the current attendance value as CourseAttendance
                      targetPercentage: 75,
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