class TrackAttendance {
  final String username;
  final String course;
  final DateTime date;
  final String session;
  final String year;
  final String semester;

  TrackAttendance({
    required this.username,
    required this.course,
    required this.date,
    required this.session,
    required this.year,
    required this.semester,
  });

  factory TrackAttendance.fromJson(Map<String, dynamic> json) {
    return TrackAttendance(
      username: json['username'] ?? '',
      course: json['course'] ?? '',
      date: DateTime.parse(json['date']),
      session: json['session'] ?? '',
      year: json['year'] ?? '',
      semester: json['semester'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'course': course,
      'date': date.toIso8601String(),
      'session': session,
      'year': year,
      'semester': semester,
    };
  }
}