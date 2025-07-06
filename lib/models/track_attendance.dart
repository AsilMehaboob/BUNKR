// models/track_attendance.dart
class TrackAttendance {
  final String username;
  final String course;
  final DateTime date;
  final String session;
  final String semester;
  final String year;
  final String status;

  TrackAttendance({
    required this.username,
    required this.course,
    required this.date,
    required this.session,
    required this.semester,
    required this.year,
    required this.status,
  });

  factory TrackAttendance.fromJson(Map<String, dynamic> json) {
    return TrackAttendance(
      username: json['username'],
      course: json['course'],
      date: DateTime.parse(json['date']),
      session: json['session'],
      semester: json['semester'],
      year: json['year'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'course': course,
    'date': date.toIso8601String(),
    'session': session,
    'semester': semester,
    'year': year,
    'status': status,
  };
}