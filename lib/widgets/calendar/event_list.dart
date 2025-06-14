// event_list.dart
import 'package:flutter/material.dart';
import 'calendar_controller.dart';
import 'calendar_utils.dart';

class EventListWidget extends StatelessWidget {
  final CalendarController controller;

  const EventListWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDate = controller.selectedDay ?? controller.focusedDay;
    final normalizedDate = DateTime(
      selectedDate.year, 
      selectedDate.month, 
      selectedDate.day
    );
    final events = controller.getEventsForDay(normalizedDate);
    final dateDetails = controller.getDateDetails(normalizedDate);
    
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.grey[900],
      child: SizedBox(
        height: 350, // Fixed height
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
            if (dateDetails != null)
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
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
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