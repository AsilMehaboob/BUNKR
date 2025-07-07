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

  String _formatDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String suffix;
    if (day.endsWith('1') && day != '11') {
      suffix = 'st';
    } else if (day.endsWith('2') && day != '12') {
      suffix = 'nd';
    } else if (day.endsWith('3') && day != '13') {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }
    String month = DateFormat('MMMM').format(date);
    String year = DateFormat('y').format(date);
    return '$day$suffix $month, $year';
  }

  String _convertSessionToHour(String sessionName) {
    // Map Roman numerals to ordinal numbers
    const romanToOrdinal = {
      'I': '1st',
      'II': '2nd',
      'III': '3rd',
      'IV': '4th',
      'V': '5th',
      'VI': '6th',
      'VII': '7th',
    };

    String ordinal = romanToOrdinal[sessionName] ?? sessionName;
    return '$ordinal Hour';
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = controller.selectedDay ?? controller.focusedDay;
    final normalizedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final events = controller.getEventsForDay(normalizedDate);

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 26),
      padding: const EdgeInsets.only(top: 0, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0x60313131),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0x80313131),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(
                bottom: BorderSide(color: Color(0xFF212121)),
              ),
            ),
            child: Center(
              child: Text(
                _formatDate(normalizedDate),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(255, 255, 255, 0.5),
                      fontSize: 16,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300, // Fixed height for content area
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: events.isEmpty
                  ? const Center(
                      child: SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'There are no classes or events\n scheduled for this date.',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          decoration: BoxDecoration(
                            color: getCodeColor(event.attendanceCode)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: getCodeColor(event.attendanceCode)
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              event.courseName.toTitleCase(),
                              style: TextStyle(
                                  color: getCodeColor(event.attendanceCode),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              _convertSessionToHour(event.sessionName),
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
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
          ),
        ],
      ),
    );
  }
}
