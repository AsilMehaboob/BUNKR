import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/course.dart';
import '../models/course_attendance.dart';
import 'auth_service.dart';
import 'config_service.dart';

class AttendanceService {
  final AuthService _authService = AuthService();
  final String baseUrl = ConfigService.apiBaseUrl;

  Future<List<Course>> fetchCourses(String semester, String year) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse(
        '$baseUrl/institutionuser/courses/withusers?semester=$semester&year=$year',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((j) => Course.fromJson(j)).toList();
    }
    throw Exception('Failed to load courses (status ${response.statusCode})');
  }

  Future<Map<String, CourseAttendance>> fetchCourseAttendances(
      String semester, String year) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/attendancereports/student/detailed'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'semester': semester, 'year': year}),
    );
    if (response.statusCode == 200) {
      return _parseAttendanceData(json.decode(response.body));
    }
    throw Exception('Failed to load attendance (status ${response.statusCode})');
  }

  Future<void> updateDefaultAcademicYear(String year) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/user/setting/default_academic_year'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'default_academic_year': year}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update academic year (status ${response.statusCode})');
    }
  }

  Future<void> updateDefaultSemester(String semester) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/user/setting/default_semester'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'default_semester': semester}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update semester (status ${response.statusCode})');
    }
  }

  Map<String, CourseAttendance> _parseAttendanceData(Map<String, dynamic> data) {
    final attendances = <String, CourseAttendance>{};

    data['studentAttendanceData'].forEach((date, sessions) {
      sessions.forEach((sessionId, session) {
        if (session['course'] != null) {
          final courseId = session['course'].toString();
          final attendanceType = session['attendance'] as int;
          final isPresent = attendanceType == 110;
          final isAbsent = attendanceType == 111;

          attendances.update(
            courseId,
            (existing) {
              final newPresent = existing.present + (isPresent ? 1 : 0);
              final newAbsent = existing.absent + (isAbsent ? 1 : 0);
              final newTotal = existing.total + 1;
              return CourseAttendance(
                courseId: courseId,
                code: existing.code,
                name: existing.name,
                present: newPresent,
                absent: newAbsent,
                total: newTotal,
                percentage: (newPresent / newTotal) * 100,
              );
            },
            ifAbsent: () {
              final presentCount = isPresent ? 1 : 0;
              final absentCount = isAbsent ? 1 : 0;
              return CourseAttendance(
                courseId: courseId,
                code: data['courses'][courseId]['code'],
                name: data['courses'][courseId]['name'],
                present: presentCount,
                absent: absentCount,
                total: 1,
                percentage: presentCount * 100,
              );
            },
          );
        }
      });
    });

    return attendances;
  }


  Future<Map<DateTime, Map<String, dynamic>>> fetchAttendanceCalendar(
      String semester, String year) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/attendancereports/student/detailed'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'semester': semester, 'year': year}),
    );
    
    if (response.statusCode == 200) {
      return _parseCalendarData(json.decode(response.body));
    }
    throw Exception('Failed to load calendar data (status ${response.statusCode})');
  }

  Map<DateTime, Map<String, dynamic>> _parseCalendarData(Map<String, dynamic> data) {
  final calendarData = <DateTime, Map<String, dynamic>>{};
  
  data['studentAttendanceData'].forEach((dateStr, sessions) {
    final date = DateTime(
      int.parse(dateStr.substring(0, 4)),
      int.parse(dateStr.substring(4, 6)),
      int.parse(dateStr.substring(6, 8)),
    );
    
    final dayData = <String, dynamic>{
      'dateDetails': data['attendanceDatesArray'][dateStr],
      'sessions': sessions,
      'courses': data['courses'],
      'sessionsInfo': data['sessions'],
      'attendanceTypes': data['attendanceTypes'],
    };
    
    calendarData[date] = dayData;
  });
  
  return calendarData;
}
}
