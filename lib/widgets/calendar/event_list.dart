import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bunkr/services/tracking_service.dart';
import 'package:bunkr/services/auth_service.dart';
import 'package:bunkr/services/settings_service.dart';
import 'package:bunkr/models/calendar_event.dart';
import 'package:bunkr/models/track_attendance.dart';
import 'calendar_utils.dart';
import 'calendar_controller.dart';

class EventListWidget extends StatelessWidget {
  final CalendarController controller;
  final String supabaseFunctionUrl; // Add this

  const EventListWidget({
    Key? key, 
    required this.controller,
    required this.supabaseFunctionUrl, // Add this
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = controller.selectedDay ?? controller.focusedDay;
    final normalizedDate = DateTime(
      selectedDate.year, 
      selectedDate.month, 
      selectedDate.day
    );
    final events = controller.getEventsForDay(normalizedDate);
    
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.grey[900],
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!, width: 2),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _formatDate(normalizedDate),
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
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final color = getCodeColor(event.attendanceCode);
                        
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              event.courseName,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Session ${event.sessionName}',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            trailing: event.attendanceCode == 'AB' // Only for absent events
                                ? FutureBuilder<String?>(
                                    future: Provider.of<AuthService>(context, listen: false).getToken(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(color),
                                          ),
                                        );
                                      }
                                      
                                      if (!snapshot.hasData) return SizedBox();
                                      
                                      return IconButton(
                                        icon: Icon(Icons.add, color: Colors.blue),
                                        onPressed: () async {
                                          final authService = Provider.of<AuthService>(context, listen: false);
                                          final username = await authService.getUsername();
                                          final token = snapshot.data;
                                          final settings = Provider.of<SettingsService>(context, listen: false);
                                          final trackingService = TrackingService(baseUrl: supabaseFunctionUrl);
                                          
                                          if (token == null || username == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Please log in first'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          try {
                                            await trackingService.addToTracking(
                                              token: token,
                                              record: TrackAttendance(
                                                username: username,
                                                course: event.courseName,
                                                date: event.date,
                                                session: event.sessionName,
                                                year: settings.year,
                                                semester: settings.semester,
                                              ),
                                            );
                                            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Added to tracking'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Failed to add: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  )
                                : Text(
                                    event.attendanceCode,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}