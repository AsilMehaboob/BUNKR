// home_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

/// Represents a course’s basic info.
class Course {
  final String id;
  final String code;
  final String name;
  final String academicYear;
  final String semester;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.academicYear,
    required this.semester,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      code: json['code'],
      name: json['name'],
      academicYear: json['academic_year'],
      semester: json['academic_semester'],
    );
  }
}

/// Aggregated attendance data for a single course.
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

/// Handles fetching courses and attendance from your backend.
class AttendanceService {
  final AuthService _authService = AuthService();
  final String baseUrl = 'https://production.api.ezygo.app/api/v1/Xcr45_salt';

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
    throw Exception(
        'Failed to load attendance (status ${response.statusCode})');
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
      throw Exception(
          'Failed to update academic year (status ${response.statusCode})');
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
      throw Exception(
          'Failed to update semester (status ${response.statusCode})');
    }
  }

  Map<String, CourseAttendance> _parseAttendanceData(
      Map<String, dynamic> data) {
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
}

/// The main screen showing semester selector and course cards.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AttendanceService _service = AttendanceService();
  late String _selectedSemester = 'even';
  late String _selectedYear = '2024-25';
  late Future<List<Course>> _courses;
  late Future<Map<String, CourseAttendance>> _attendances;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _courses =
          _service.fetchCourses(_selectedSemester, _selectedYear);
      _attendances =
          _service.fetchCourseAttendances(_selectedSemester, _selectedYear);
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF121212),
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              Color(0xFF6CA2AB),
              Color(0xFFB0CBCA),
              Color(0xFFCCD9D6),
              Color(0xFFEDBEA2),
            ],
            stops: [0.0, 0.35, 0.65, 1.0], // Optional: control color distribution
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Text(
          'bunkr',
          style: TextStyle(
            fontSize: 24, // Adjust size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.white,
          onPressed: _refreshData,
        ),
      ],
    ),
    body: RefreshIndicator(
      onRefresh: () async => _refreshData(),
      color: Colors.white,
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSemesterYearSelector(),
            SizedBox(height: 20),
            FutureBuilder<List<Course>>(
              future: _courses,
              builder: (ctx, snapCourses) {
                return FutureBuilder<Map<String, CourseAttendance>>(
                  future: _attendances,
                  builder: (ctx2, snapAttend) {
                    if (!snapCourses.hasData || !snapAttend.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    }
                    return _buildCourseGrid(
                        snapCourses.data!, snapAttend.data!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildSemesterYearSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dropdown<String>(
          value: _selectedSemester,
          items: ['even', 'odd'],
          labelBuilder: (s) => s.toLowerCase(),
          onChanged: (v) {
            if (v != null) _onSelectionChanged(v, _selectedYear);
          },
        ),
        SizedBox(width: 16),
        _dropdown<String>(
          value: _selectedYear,
          items: ['2023-24', '2024-25', '2025-26'],
          labelBuilder: (y) => y,
          onChanged: (v) {
            if (v != null) _onSelectionChanged(_selectedSemester, v);
          },
        ),
      ],
    );
  }

  DropdownButton<T> _dropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButton<T>(
      dropdownColor: Color(0xFF1E1E1E),
      value: value,
      style: TextStyle(color: Colors.white),
      underline: Container(height: 1, color: Colors.grey[700]),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(labelBuilder(e),
                    style: TextStyle(color: Colors.white)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  void _onSelectionChanged(String sem, String yr) async {
    final oldSem = _selectedSemester;
    final oldYr = _selectedYear;
    setState(() {
      _selectedSemester = sem;
      _selectedYear = yr;
    });

    bool error = false;
    if (sem != oldSem) {
      try {
        await _service.updateDefaultSemester(sem);
      } catch (_) {
        error = true;
        setState(() => _selectedSemester = oldSem);
      }
    }
    if (yr != oldYr) {
      try {
        await _service.updateDefaultAcademicYear(yr);
      } catch (_) {
        error = true;
        setState(() => _selectedYear = oldYr);
      }
    }
    if (!error) _refreshData();
  }

  Widget _buildCourseGrid(
    List<Course> courses,
    Map<String, CourseAttendance> attendances,
  ) {
    final crossCount = MediaQuery.of(context).size.width > 600 ? 2 : 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (ctx, i) {
        return CourseCard(
          course: courses[i],
          attendance: attendances[courses[i].id],
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final CourseAttendance? attendance;

  const CourseCard({
    Key? key,
    required this.course,
    this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pct = (attendance?.percentage ?? 0) / 100;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with course code and year/semester
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  course.code,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              Text(
                '${course.academicYear} • ${course.semester}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 9,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4),
          
          // Course name
          Text(
            course.name.toLowerCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          if (attendance != null) ...[
            SizedBox(height: 6),
            
            // Stats row
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statBlock('Present', attendance!.present.toString(), Colors.green),
                  _statBlock('Absent', attendance!.absent.toString(), Colors.red),
                  _statBlock('Total', attendance!.total.toString(), Colors.grey),
                ],
              ),
            ),
            
            // Attendance bar with labels
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attendance',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${attendance!.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: pct,
                    backgroundColor: Colors.grey[700],
                    valueColor: AlwaysStoppedAnimation(
                      pct >= 0.75 ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                _buildBunkMessage(attendance!),
              ],
            ),
          ] else ...[
            SizedBox(height: 8),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No attendance data',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Attendance records not updated',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statBlock(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBunkMessage(CourseAttendance attendance) {
    final present = attendance.present;
    final total = attendance.total;
    final percentage = attendance.percentage;

    String message;
    Color color;

    if (percentage < 75) {
      final required = (3 * total - 4 * present).clamp(0, double.infinity).toInt();
      message = 'Attend $required more to reach 75%';
      color = Colors.red[400]!;
    } else if (percentage > 75) {
      final bunkable = ((4 * present - 3 * total) ~/ 3).clamp(0, double.infinity).toInt();
      message = 'Can bunk $bunkable safely';
      color = Colors.green[400]!;
    } else {
      message = 'Perfect 75% attendance';
      color = Colors.grey;
    }

    return Text(
      message,
      style: TextStyle(
        color: color,
        fontSize: 9,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

