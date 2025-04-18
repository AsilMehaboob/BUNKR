// home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

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

class AttendanceService {
  final AuthService _authService = AuthService();
  final String baseUrl = 'https://production.api.ezygo.app/api/v1/Xcr45_salt';

  Future<List<Course>> fetchCourses(String semester, String year) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/institutionuser/courses/withusers?semester=$semester&year=$year'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Course.fromJson(json)).toList();
    }
    throw Exception('Failed to load courses');
  }

  Future<Map<String, CourseAttendance>> fetchCourseAttendances(String semester, String year) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/attendancereports/student/detailed'),
      headers: {'Authorization': 'Bearer $token'},
      body: json.encode({'semester': semester, 'year': year}),
    );

    if (response.statusCode == 200) {
      return _parseAttendanceData(json.decode(response.body));
    }
    throw Exception('Failed to load attendance');
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
      throw Exception('Failed to update academic year');
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
      throw Exception('Failed to update semester');
    }
  }

  Map<String, CourseAttendance> _parseAttendanceData(Map<String, dynamic> data) {
    Map<String, CourseAttendance> attendances = {};
    
    data['studentAttendanceData'].forEach((date, sessions) {
      sessions.forEach((sessionId, session) {
        if (session['course'] != null) {
          final courseId = session['course'].toString();
          final attendanceType = session['attendance'];
          
          attendances.update(courseId, (existing) {
            final present = attendanceType == 110 ? 1 : 0;
            final absent = attendanceType == 111 ? 1 : 0;
            return CourseAttendance(
              courseId: courseId,
              code: existing.code,
              name: existing.name,
              present: existing.present + present,
              absent: existing.absent + absent,
              total: existing.total + 1,
              percentage: ((existing.present + present) / (existing.total + 1)) * 100,
            );
          }, ifAbsent: () {
            final present = attendanceType == 110 ? 1 : 0;
            final absent = attendanceType == 111 ? 1 : 0;
            return CourseAttendance(
              courseId: courseId,
              code: data['courses'][courseId]['code'],
              name: data['courses'][courseId]['name'],
              present: present,
              absent: absent,
              total: 1,
              percentage: (present / 1) * 100,
            );
          });
        }
      });
    });
    
    return attendances;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AttendanceService _service = AttendanceService();
  late String _selectedSemester = 'odd';
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
      _courses = _service.fetchCourses(_selectedSemester, _selectedYear);
      _attendances = _service.fetchCourseAttendances(_selectedSemester, _selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: _service._authService.getToken(),
          builder: (context, snapshot) {
            return Text(snapshot.hasData 
                ? 'Welcome Back' 
                : 'Attendance Dashboard');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSemesterYearSelector(),
              SizedBox(height: 20),
              FutureBuilder<Map<String, CourseAttendance>>(
                future: _attendances,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildOverallStats(snapshot.data!);
                  }
                  return _buildLoadingStats();
                },
              ),
              SizedBox(height: 20),
              FutureBuilder<List<Course>>(
                future: _courses,
                builder: (context, coursesSnapshot) {
                  return FutureBuilder<Map<String, CourseAttendance>>(
                    future: _attendances,
                    builder: (context, attendanceSnapshot) {
                      if (coursesSnapshot.hasData && attendanceSnapshot.hasData) {
                        return _buildCourseGrid(
                          coursesSnapshot.data!,
                          attendanceSnapshot.data!,
                        );
                      }
                      return _buildCourseShimmers();
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
      children: [
        DropdownButton<String>(
          value: _selectedSemester,
          items: ['even', 'odd'].map((semester) => DropdownMenuItem(
            value: semester,
            child: Text(semester.capitalize()),
          )).toList(),
          onChanged: (value) => _updateSelection(value!, _selectedYear),
        ),
        SizedBox(width: 20),
        DropdownButton<String>(
          value: _selectedYear,
          items: ['2023-24', '2024-25', '2025-26'].map((year) => DropdownMenuItem(
            value: year,
            child: Text(year),
          )).toList(),
          onChanged: (value) => _updateSelection(_selectedSemester, value!),
        ),
      ],
    );
  }

  void _updateSelection(String newSemester, String newYear) async {
    final oldSemester = _selectedSemester;
    final oldYear = _selectedYear;

    setState(() {
      _selectedSemester = newSemester;
      _selectedYear = newYear;
    });

    bool hasError = false;

    if (newSemester != oldSemester) {
      try {
        await _service.updateDefaultSemester(newSemester);
      } catch (e) {
        hasError = true;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update semester: ${e.toString()}')),
          );
          setState(() => _selectedSemester = oldSemester);
        }
      }
    }

    if (newYear != oldYear) {
      try {
        await _service.updateDefaultAcademicYear(newYear);
      } catch (e) {
        hasError = true;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update academic year: ${e.toString()}')),
          );
          setState(() => _selectedYear = oldYear);
        }
      }
    }

    if (!hasError) _refreshData();
  }

  Widget _buildOverallStats(Map<String, CourseAttendance> attendances) {
    final totalPresent = attendances.values.fold(0, (sum, a) => sum + a.present);
    final totalAbsent = attendances.values.fold(0, (sum, a) => sum + a.absent);
    final total = totalPresent + totalAbsent;
    final percentage = total > 0 ? (totalPresent / total * 100).round() : 0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      children: [
        _buildStatCard('Total Attendance', '$percentage%', Colors.blue),
        _buildStatCard('Present', '$totalPresent', Colors.green),
        _buildStatCard('Absent', '$totalAbsent', Colors.red),
        _buildStatCard('Total Courses', '${attendances.length}', Colors.purple),
      ],
    );
  }

  Widget _buildCourseGrid(List<Course> courses, Map<String, CourseAttendance> attendances) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: courses.map((course) => _buildCourseCard(course, attendances[course.id])).toList(),
    );
  }

  Widget _buildCourseCard(Course course, [CourseAttendance? attendance]) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(course.code),
                  backgroundColor: Colors.blue[50],
                ),
                Spacer(),
                Text(
                  '${course.academicYear} • ${course.semester}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              course.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            if (attendance != null && attendance.total > 0) ...[
              _buildAttendanceRow('Present', attendance.present, Colors.green),
              _buildAttendanceRow('Absent', attendance.absent, Colors.red),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: attendance.percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(
                  attendance.percentage >= 75 ? Colors.green : Colors.orange,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Attendance: ${attendance.percentage.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 12),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRow(String label, int count, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: color)),
          Spacer(),
          Text('$count', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: color)),
            SizedBox(height: 8),
            Text(value, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingStats() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      children: List.generate(4, (index) => Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 16,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              Container(
                width: 60,
                height: 24,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildCourseShimmers() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      children: List.generate(6, (index) => Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 24,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              Container(
                height: 16,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              Container(
                height: 16,
                width: 100,
                color: Colors.grey[300],
              ),
              Spacer(),
              Container(
                height: 4,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}