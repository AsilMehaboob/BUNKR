import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_controller.dart';
import 'calendar_utils.dart';
import '../../models/calendar_event.dart';

CalendarBuilders<CalendarEvent> createCalendarBuilders({
  required CalendarController controller,
}) {
  return CalendarBuilders(
    defaultBuilder: (context, day, focusedDay) {
      final status = controller.getDayStatus(day);
      final hasEvents = controller.getEventsForDay(day).isNotEmpty;
      final isToday = isSameDay(day, DateTime.now());
      final isSelected = isSameDay(day, controller.selectedDay);

      Color backgroundColor = Colors.transparent;
      Color textColor = Colors.white;
      Color borderColor = Colors.transparent;
      double borderWidth = 0;
      FontWeight fontWeight = FontWeight.normal;
      bool hasShadow = false;
      double scale = 1.0;

      // Apply styling based on selection and status
      if (isSelected) {
        backgroundColor = Colors.white;
        textColor = Colors.black;
        fontWeight = FontWeight.w500;
        hasShadow = true;
        scale = 1.1;
      } else if (status == "absent") {
        backgroundColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red[400]!;
        borderColor = Colors.red.withOpacity(0.3);
        borderWidth = 1;
      } else if (status == "otherLeave") {
        backgroundColor = Colors.teal.withOpacity(0.2);
        textColor = Colors.teal[400]!;
        borderColor = Colors.teal.withOpacity(0.3);
        borderWidth = 1;
      } else if (status == "dutyLeave") {
        backgroundColor = Colors.yellow.withOpacity(0.2);
        textColor = Colors.yellow[700]!;
        borderColor = Colors.yellow.withOpacity(0.3);
        borderWidth = 1;
      } else if (status == "present") {
        backgroundColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue[400]!;
        borderColor = Colors.blue.withOpacity(0.3);
        borderWidth = 1;
      } else if (hasEvents) {
        borderColor = Colors.grey.withOpacity(0.3);
        borderWidth = 1;
      }

      // Add today styling if not selected
      if (isToday && !isSelected) {
        borderColor = Colors.white;
        borderWidth = 2;
      }

      return Transform.scale(
        scale: scale,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            boxShadow: hasShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      );
    },
    todayBuilder: (context, day, focusedDay) {
      return createCalendarBuilders(controller: controller)
          .defaultBuilder!(context, day, focusedDay);
    },
    selectedBuilder: (context, day, focusedDay) {
      return createCalendarBuilders(controller: controller)
          .defaultBuilder!(context, day, focusedDay);
    },
  );
}