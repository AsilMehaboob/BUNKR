import 'package:flutter/material.dart';
import '../../models/calendar_event.dart';

Color getStatusColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red': return Colors.red;
    case 'blue': return Colors.blue;
    case 'yellow': return Colors.yellow;
    case 'teal': return Colors.teal;
    case 'grey': return Colors.grey;
    default: return Colors.grey;
  }
}

Color getCodeColor(String code) {
  switch (code.toUpperCase()) {
    case 'P': return Colors.green;
    case 'AB': return Colors.red;
    case 'D': return Colors.yellow;
    default: return getStatusColor('grey');
  }
}

String? calculateDayStatus(List<CalendarEvent> events) {
  if (events.isEmpty) return null;
  
  bool hasAbsent = false;
  bool hasOtherLeave = false;
  bool hasDutyLeave = false;
  bool hasPresent = false;

  for (final event in events) {
    switch (event.attendanceTypeId) {
      case '111': hasAbsent = true; break;
      case '112': hasOtherLeave = true; break;
      case '225': hasDutyLeave = true; break;
      case '110': hasPresent = true; break;
    }
  }

  if (hasAbsent) return 'absent';
  if (hasOtherLeave) return 'otherLeave';
  if (hasDutyLeave) return 'dutyLeave';
  if (hasPresent) return 'present';
  
  return null;
}

Color getDayStatusColorFromString(String status) {
  switch (status) {
    case 'absent': return Colors.red.withOpacity(0.2);
    case 'otherLeave': return Colors.teal.withOpacity(0.2);
    case 'dutyLeave': return Colors.yellow.withOpacity(0.2);
    case 'present': return Colors.blue.withOpacity(0.2);
    default: return Colors.transparent;
  }
}

// New function to get status text color
Color getStatusTextColor(String status) {
  switch (status) {
    case 'absent': return Colors.red[400]!;
    case 'otherLeave': return Colors.teal[400]!;
    case 'dutyLeave': return Colors.yellow[700]!;
    case 'present': return Colors.blue[400]!;
    default: return Colors.white;
  }
}