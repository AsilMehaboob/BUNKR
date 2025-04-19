class CourseAttendance {
  final String courseId;
  final String code;
  final String name;
  final int present;
  final int absent;
  final int total;
  final double percentage;

  CourseAttendance({
    required this.courseId,
    required this.code,
    required this.name,
    required this.present,
    required this.absent,
    required this.total,
    required this.percentage,
  });
}