// event_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import 'calendar_controller.dart';
import 'calendar_utils.dart';


extension StringCasingExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
}

class EventListWidget extends StatelessWidget {
  final CalendarController controller;

  const EventListWidget({Key? key, required this.controller}) : super(key: key);

  // Helper function to format date
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
        height: 350, // Fixed height
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!, width: 2),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            // Always show formatted date
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _formatDate(normalizedDate), // Use formatted date
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
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: getCodeColor(event.attendanceCode).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: getCodeColor(event.attendanceCode).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              event.courseName.toTitleCase(),
                              style: TextStyle(color: getCodeColor(event.attendanceCode)),
                            ),
                            subtitle: Text(
                              'Session ${event.sessionName}',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            trailing: Text(
                              event.attendanceCode,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getCodeColor(event.attendanceCode),
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