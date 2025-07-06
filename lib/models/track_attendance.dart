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

  factory TrackAttendance.fromJson(Map<dynamic, dynamic> json) {
    String getNonNullString(String? value) => value ?? '';

    return TrackAttendance(
      username: getNonNullString(json['username']),
      course: getNonNullString(json['course']),
      date: DateTime.parse(json['date']),
      session: getNonNullString(json['session']),
      semester: getNonNullString(json['semester']),
      year: getNonNullString(json['year']),
      status: getNonNullString(json['status']),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        'username': username,
        'course': course,
        'date': date.toIso8601String(),
        'session': session,
        'semester': semester,
        'year': year,
        'status': status,
      };
}
