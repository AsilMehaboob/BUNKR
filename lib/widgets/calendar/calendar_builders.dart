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
      final isToday = isSameDay(day, DateTime.now());
      final isSelected = isSameDay(day, controller.selectedDay);
      
      return Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: status != null 
              ? getDayStatusColorFromString(status) 
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
      final status = controller.getDayStatus(day);
      final isSelected = isSameDay(day, controller.selectedDay);
      
      return Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: status != null 
              ? getDayStatusColorFromString(status) 
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
  );
}