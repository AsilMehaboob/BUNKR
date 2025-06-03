import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '/services/attendance_service.dart';
import '/models/calendar_event.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, Map<String, dynamic>> _calendarData = {};
  Map<DateTime, List<CalendarEvent>> _events = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCalendarData();
  }

  Future<void> _fetchCalendarData() async {
    try {
      final attendanceService = AttendanceService();
      final data = await attendanceService.fetchAttendanceCalendar('odd', '2024-25');
      
      final events = <DateTime, List<CalendarEvent>>{};
      
      data.forEach((date, dayData) {
        final sessions = dayData['sessions'] as Map<String, dynamic>;
        final dateDetails = dayData['dateDetails'] as Map<String, dynamic>;
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
  courseId: courseId ?? 'N/A',
  courseCode: course?['code']?.toString() ?? 'N/A',
  courseName: course?['name']?.toString() ?? 'N/A',
  sessionId: sessionId ?? 'N/A',
  sessionName: session?['name']?.toString() ?? 'N/A',
  attendanceCode: attendanceType?['code']?.toString() ?? 'N/A',
  attendanceColor: attendanceType?['color']?.toString() ?? 'grey',
  attendanceTypeId: attendanceTypeId ?? 'N/A',
));
              ;
            }
          }
        });
        
        events[date] = dayEvents;
      });
      
      setState(() {
        _calendarData = data;
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching calendar data: $e');
      setState(() => _isLoading = false);
    }
  }


    Color _getStatusColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'teal':
        return Colors.teal;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
  
  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  // New: Get day status based on worst attendance record
  String? _getDayStatus(DateTime day) {
    final events = _getEventsForDay(day);
    if (events.isEmpty) return null;
    
    bool hasAbsent = false;
    bool hasOtherLeave = false;
    bool hasDutyLeave = false;
    bool hasPresent = false;

    for (final event in events) {
      // Using numeric IDs from React implementation:
      // 111: Absent, 112: Other Leave, 225: Duty Leave, 110: Present
      switch (event.attendanceTypeId) {
        case '111':
          hasAbsent = true;
          break;
        case '112':
          hasOtherLeave = true;
          break;
        case '225':
          hasDutyLeave = true;
          break;
        case '110':
          hasPresent = true;
          break;
      }
    }

    if (hasAbsent) return 'absent';
    if (hasOtherLeave) return 'otherLeave';
    if (hasDutyLeave) return 'dutyLeave';
    if (hasPresent) return 'present';
    
    return null;
  }

  // New: Get color for day status
  Color _getDayStatusColor(String status) {
    switch (status) {
      case 'absent':
        return Colors.red.withOpacity(0.2);
      case 'otherLeave':
        return Colors.teal.withOpacity(0.2);
      case 'dutyLeave':
        return Colors.yellow.withOpacity(0.2);
      case 'present':
        return Colors.blue.withOpacity(0.2);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        dialogBackgroundColor: Colors.grey[900],
        dividerColor: Colors.grey[800],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(8),
              color: Colors.grey[900],
              child: TableCalendar<CalendarEvent>(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white),
                  outsideTextStyle: TextStyle(color: Colors.grey),
                  disabledTextStyle: TextStyle(color: Colors.grey[600]),
                  todayTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  // Remove markers since we're coloring cells instead
                  markersMaxCount: 0,
                  markerSize: 0,
                  markerMargin: EdgeInsets.zero,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                // New: Custom day builder for status coloring
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final status = _getDayStatus(day);
                    final isToday = isSameDay(day, DateTime.now());
                    final isSelected = isSameDay(day, _selectedDay);
                    
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: status != null 
                            ? _getDayStatusColor(status)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isToday
                            ? Border.all(color: Colors.orange, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isSelected 
                                ? Colors.white 
                                : (isToday ? Colors.black : Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final status = _getDayStatus(day);
                    final isSelected = isSameDay(day, _selectedDay);
                    
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: status != null 
                            ? _getDayStatusColor(status)
                            : Colors.orange.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    final status = _getDayStatus(day);
                    final isToday = isSameDay(day, DateTime.now());
                    
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: isToday
                            ? Border.all(color: Colors.orange, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildEventList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final selectedDate = _selectedDay ?? _focusedDay;
    final normalizedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final events = _getEventsForDay(normalizedDate);
    final dateDetails = _calendarData[normalizedDate]?['dateDetails'];
    
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.grey[900],
      child: Column(
        children: [
          if (dateDetails != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${dateDetails['day']}, ${dateDetails['date']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          Divider(height: 1, color: Colors.grey[800]),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'No attendance records for this day',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _getStatusColor(event.attendanceColor),
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(
                          event.courseName,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Session ${event.sessionName}',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        trailing: Text(
                          event.attendanceCode,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(event.attendanceColor),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}