class CalendarEvent {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String sessionId;
  final String sessionName;
  final String attendanceCode;
  final String attendanceColor;
  final String attendanceTypeId;
  final DateTime date; // Add this property

  CalendarEvent({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.sessionId,
    required this.sessionName,
    required this.attendanceCode,
    required this.attendanceColor,
    required this.attendanceTypeId,
    required this.date, // Add this
  });
}