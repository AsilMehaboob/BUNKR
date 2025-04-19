import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/attendance_service.dart';
import '../widgets/course_card.dart';
// Add this import at the top
import '../models/course_attendance.dart';

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
      _courses = _service.fetchCourses(_selectedSemester, _selectedYear);
      _attendances = _service.fetchCourseAttendances(_selectedSemester, _selectedYear);
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
              stops: [0.0, 0.35, 0.65, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            'bunkr',
            style: TextStyle(
              fontSize: 24,
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
                      return _buildCourseGrid(snapCourses.data!, snapAttend.data!);
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
    dropdownColor: const Color(0xFF1E1E1E),
    value: value,
    style: const TextStyle(color: Colors.white),
    underline: Container(height: 1, color: Colors.grey[700]),
    items: items
        .map((e) => DropdownMenuItem<T>(
              value: e,
              child: Text(
                labelBuilder(e),
                style: const TextStyle(color: Colors.white),
              ),
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