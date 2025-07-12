import 'package:dio/dio.dart';
import '../models/course.dart';
import '../models/course_attendance.dart';
import 'auth_service.dart';
import 'config_service.dart';

class AttendanceService {
  final AuthService _authService = AuthService();
  final Dio _dio = Dio();
  final String baseUrl = ConfigService.apiBaseUrl;

  Future<List<Course>> fetchCourses(String semester, String year) async {
    try {
      final token = await _authService.getToken();
      final response = await _dio.get(
        '$baseUrl/institutionuser/courses/withusers',
        queryParameters: {'semester': semester, 'year': year},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data == null || 
          response.data is! List || 
          (response.data as List).isEmpty) {
        return [];
      }
      final data = response.data as List;
      return data.map((j) => Course.fromJson(j)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, CourseAttendance>> fetchCourseAttendances(
      String semester, String year) async {
    try {
      final token = await _authService.getToken();
      final response = await _dio.post(
        '$baseUrl/attendancereports/student/detailed',
        data: {'semester': semester, 'year': year},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return _parseAttendanceData(response.data);
    } catch (e) {
      return {};
    }
  }

  Future<void> updateDefaultAcademicYear(String year) async {
    final token = await _authService.getToken();
    final response = await _dio.post(
      '$baseUrl/user/setting/default_academic_year',
      data: {'default_academic_year': year},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update academic year (status ${response.statusCode})');
    }
  }

  Future<void> updateDefaultSemester(String semester) async {
    final token = await _authService.getToken();
    final response = await _dio.post(
      '$baseUrl/user/setting/default_semester',
      data: {'default_semester': semester},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update semester (status ${response.statusCode})');
    }
  }

  Future<Map<DateTime, Map<String, dynamic>>> fetchAttendanceCalendar(
      String semester, String year) async {
    final token = await _authService.getToken();
    final response = await _dio.post(
      '$baseUrl/attendancereports/student/detailed',
      data: {'semester': semester, 'year': year},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    return _parseCalendarData(response.data);
  }

  Map<String, CourseAttendance> _parseAttendanceData(Map<String, dynamic> data) {
    final attendances = <String, CourseAttendance>{};
    if (data['studentAttendanceData'] == null) {
      return attendances;
    }
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
                code: data['courses'][courseId]?['code'] ?? 'N/A',
                name: data['courses'][courseId]?['name'] ?? 'Unknown Course',
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

  Map<DateTime, Map<String, dynamic>> _parseCalendarData(Map<String, dynamic> data) {
    final calendarData = <DateTime, Map<String, dynamic>>{};
    if (data['studentAttendanceData'] == null) {
      return calendarData;
    }
    data['studentAttendanceData'].forEach((dateStr, sessions) {
      try {
        final date = DateTime(
          int.parse(dateStr.substring(0, 4)),
          int.parse(dateStr.substring(4, 6)),
          int.parse(dateStr.substring(6, 8)),
        );
        final dayData = <String, dynamic>{
          'dateDetails': data['attendanceDatesArray'][dateStr],
          'sessions': sessions,
          'courses': data['courses'] ?? {},
          'sessionsInfo': data['sessions'] ?? {},
          'attendanceTypes': data['attendanceTypes'] ?? {},
        };
        calendarData[date] = dayData;
      } catch (e) {}
    });
    return calendarData;
  }
}
