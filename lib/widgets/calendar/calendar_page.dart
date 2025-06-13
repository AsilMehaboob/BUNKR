import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_controller.dart';
import 'calendar_builders.dart';
import 'event_list.dart';
import '../../models/calendar_event.dart';
import 'calendar_utils.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarController(),
      child: Consumer<CalendarController>(
        builder: (context, controller, _) {
          return Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              cardColor: Colors.grey[900],
              dialogBackgroundColor: Colors.grey[900],
              dividerColor: Colors.grey[800],
              textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
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
                      focusedDay: controller.focusedDay,
                      calendarFormat: controller.calendarFormat,
                      selectedDayPredicate: (day) =>
                          isSameDay(controller.selectedDay, day),
                      onDaySelected: controller.onDaySelected,
                      onFormatChanged: controller.onFormatChanged,
                      onPageChanged: controller.onPageChanged,
                      eventLoader: controller.getEventsForDay,
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
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        markersMaxCount: 0,
                        markerSize: 0,
                        markerMargin: EdgeInsets.zero,
                        selectedDecoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                        weekendDecoration:
                            BoxDecoration(shape: BoxShape.circle),
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
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Colors.white),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.white),
                        decoration: BoxDecoration(color: Colors.grey[900]),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.white),
                        weekendStyle: TextStyle(color: Colors.white),
                      ),
                      calendarBuilders: createCalendarBuilders(
                        controller: controller
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: EventListWidget(controller: controller),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}