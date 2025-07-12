import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/attendance_service.dart';
import '../widgets/home/course_card.dart';
import '../models/course_attendance.dart';
import '../widgets/appbar/app_bar.dart';
import '../widgets/home/semester_year_selector.dart';
import '../services/settings_service.dart';

class HomeScreen extends StatefulWidget {
  final SettingsService settingsService;

  const HomeScreen({super.key, required this.settingsService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AttendanceService _service = AttendanceService();
  late int _selectedPercentage;
  late Future<List<Course>> _courses;
  late Future<Map<String, CourseAttendance>> _attendances;

  @override
  void initState() {
    super.initState();
    _selectedPercentage = widget.settingsService.targetPercentageNotifier.value;
    _refreshData();
    
    // Setup listeners for settings changes
    widget.settingsService.targetPercentageNotifier.addListener(_handlePercentageChange);
    widget.settingsService.semesterNotifier.addListener(_refreshData);
    widget.settingsService.yearNotifier.addListener(_refreshData);
  }

  @override
  void dispose() {
    widget.settingsService.targetPercentageNotifier.removeListener(_handlePercentageChange);
    widget.settingsService.semesterNotifier.removeListener(_refreshData);
    widget.settingsService.yearNotifier.removeListener(_refreshData);
    super.dispose();
  }

  void _handlePercentageChange() {
    setState(() {
      _selectedPercentage = widget.settingsService.targetPercentageNotifier.value;
    });
  }

  void _refreshData() {
    if (!mounted) return;
    
    setState(() {
      try {
        _courses = _service.fetchCourses(
          widget.settingsService.semesterNotifier.value,
          widget.settingsService.yearNotifier.value,
        );
        _attendances = _service.fetchCourseAttendances(
          widget.settingsService.semesterNotifier.value,
          widget.settingsService.yearNotifier.value,
        );
      } catch (e) {
        _courses = Future.value([]);
        _attendances = Future.value({});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        color: Colors.white,
        backgroundColor: Colors.black,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSemesterYearSelector(),
              const SizedBox(height: 20),
              FutureBuilder<List<Course>>(
                future: _courses,
                builder: (ctx, snapCourses) {
                  if (snapCourses.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  }
                  
                  if (snapCourses.hasError || !snapCourses.hasData || snapCourses.data!.isEmpty) {
                    return _buildNoCoursesMessage();
                  }
                  
                  return FutureBuilder<Map<String, CourseAttendance>>(
                    future: _attendances,
                    builder: (ctx2, snapAttend) {
                      if (snapAttend.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      }
                      
                      final attendances = snapAttend.data ?? {};
                      return _buildCourseGrid(snapCourses.data!, attendances);
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
    return SemesterYearSelector(
      selectedSemester: widget.settingsService.semesterNotifier.value,
      selectedYear: widget.settingsService.yearNotifier.value,
      onSemesterChanged: (v) => _onSelectionChanged(v, null),
      onYearChanged: (v) => _onSelectionChanged(null, v),
    );
  }

  void _onSelectionChanged(String? sem, String? yr) async {
    bool error = false;
    
    if (sem != null) {
      try {
        await _service.updateDefaultSemester(sem);
        await widget.settingsService.setSemester(sem);
      } catch (_) {
        error = true;
      }
    }
    
    if (yr != null) {
      try {
        await _service.updateDefaultAcademicYear(yr);
        await widget.settingsService.setYear(yr);
      } catch (_) {
        error = true;
      }
    }
    
    if (!error && (sem != null || yr != null)) {
      _refreshData();
    }
  }

  Widget _buildNoCoursesMessage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: const Text(
          "No courses found for this semester",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseGrid(
    List<Course> courses,
    Map<String, CourseAttendance> attendances,
  ) {
    final crossCount = MediaQuery.of(context).size.width > 600 ? 2 : 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 305,
      ),
      itemBuilder: (ctx, i) {
        return CourseCard(
          course: courses[i],
          attendance: attendances[courses[i].id],
          targetPercentage: _selectedPercentage,
        );
      },
    );
  }
}