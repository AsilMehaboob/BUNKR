import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/attendance_service.dart';
import '../../models/calendar_event.dart';
import 'calendar_utils.dart';

class CalendarController extends ChangeNotifier {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, Map<String, dynamic>> _calendarData = {};
  Map<DateTime, List<CalendarEvent>> _events = {};
  bool _isLoading = true;

  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  bool get isLoading => _isLoading;

  CalendarController() {
    _fetchCalendarData();
  }

  Future<void> _fetchCalendarData() async {
    try {
      final attendanceService = AttendanceService();
      final data = await attendanceService.fetchAttendanceCalendar('odd', '2024-25');
      
      final events = <DateTime, List<CalendarEvent>>{};
      
      data.forEach((date, dayData) {
        final sessions = dayData['sessions'] as Map<String, dynamic>;
        final courses = dayData['courses'] as Map<String, dynamic>;
        final sessionsInfo = dayData['sessionsInfo'] as Map<String, dynamic>;
        final attendanceTypes = dayData['attendanceTypes'] as Map<String, dynamic>;
        
        final dayEvents = <CalendarEvent>[];
        
        sessions.forEach((sessionId, sessionData) {
          if (sessionData['course'] != null && sessionData['attendance'] != null) {
            final courseId = sessionData['course'].toString();
            final attendanceTypeId = sessionData['attendance'].toString();
            
            final course = courses[courseId];
            final session = sessionsInfo[sessionId];
            final attendanceType = attendanceTypes[attendanceTypeId];
            
            if (course != null && session != null && attendanceType != null) {
              dayEvents.add(CalendarEvent(
                courseId: courseId,
                courseCode: course['code']?.toString() ?? 'N/A',
                courseName: course['name']?.toString() ?? 'N/A',
                sessionId: sessionId,
                sessionName: session['name']?.toString() ?? 'N/A',
                attendanceCode: attendanceType['code']?.toString() ?? 'N/A',
                attendanceColor: attendanceType['color']?.toString() ?? 'grey',
                attendanceTypeId: attendanceTypeId,
              ));
            }
          }
        });
        
        events[date] = dayEvents;
      });
      
      _calendarData = data;
      _events = events;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching calendar data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    notifyListeners();
  }

  void onFormatChanged(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  void onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Map<String, dynamic>? getDateDetails(DateTime day) {
    return _calendarData[day]?['dateDetails'];
  }

  String? getDayStatus(DateTime day) {
    return calculateDayStatus(getEventsForDay(day));
  }
}