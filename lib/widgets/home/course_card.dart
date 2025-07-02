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
    final pct = (attendance?.percentage ?? 0) / 100;
    final progressColor =
        pct >= (targetPercentage / 100) ? Colors.white : Colors.orange;
    final total = attendance?.total ?? 0;
    final hasAttendanceData = attendance != null && total > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: 200,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x90424242), width: 1),
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF181818),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.only(left: 14, right: 14, top: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(
                    bottom:
                        BorderSide(color: const Color(0x90424242), width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        course.name
                            .split(' ')
                            .map((word) => word.isNotEmpty
                                ? word[0].toUpperCase() +
                                    word.substring(1).toLowerCase()
                                : '')
                            .join(' '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0x60424242),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.code,
                      style: const TextStyle(
                        color: Color(0x90FFFFFF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: hasAttendanceData
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF181818),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StatBlock(
                                    label: 'Present',
                                    value: attendance!.present.toString(),
                                    color: Colors.grey,
                                    valueColor: Colors.green,
                                  ),
                                  StatBlock(
                                    label: 'Absent',
                                    value: attendance!.absent.toString(),
                                    color: Colors.grey,
                                    valueColor: Colors.red,
                                  ),
                                  StatBlock(
                                    label: 'Total',
                                    value: total.toString(),
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 22),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 5,
                                    backgroundColor: Colors.grey.shade800,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        progressColor),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Attendance",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${(pct * 100).toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          BunkMessage(
                            attendance: attendance!,
                            targetPercentage: targetPercentage,
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.warning_rounded,
                                        color: Colors.orange, size: 24),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "No attendance data",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              "Instructor has not updated attendance records yet",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
