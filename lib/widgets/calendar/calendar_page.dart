// calendar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'calendar_controller.dart';
import 'calendar_builders.dart';
import 'event_list.dart';
import '../../models/calendar_event.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  late List<int> _years;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    final maxYear = currentYear + 10;
    _years = List.generate(maxYear - 1999, (index) => 2000 + index);
    _years = _years.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (context) => CalendarController(),
      child: Consumer<CalendarController>(
        builder: (context, controller, _) {
          final currentMonth = controller.focusedDay.month - 1;
          final currentYear = controller.focusedDay.year;

          return Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              cardColor: Colors.grey[900],
              dividerColor: Colors.grey[800],
              textTheme: textTheme, // Use app's text theme
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    padding: const EdgeInsets.only(top: 0, bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0x60313131),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              // Month/Year selector row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Month dropdown
                                  _customDropdown<int>(
                                    value: currentMonth,
                                    items: List.generate(12, (index) => index),
                                    labelBuilder: (index) => _months[index],
                                    width: 130,
                                    onChanged: (newMonth) {
                                      final newDate = DateTime(
                                        controller.focusedDay.year,
                                        newMonth + 1,
                                        controller.focusedDay.day,
                                      );
                                      controller.onPageChanged(newDate);
                                    },
                                  ),
                                  SizedBox(width: 16),

                                  // Year dropdown
                                  _customDropdown<int>(
                                    value: currentYear,
                                    items: _years,
                                    labelBuilder: (year) => year.toString(),
                                    width: 96,
                                    onChanged: (newYear) {
                                      final newDate = DateTime(
                                        newYear,
                                        controller.focusedDay.month,
                                        controller.focusedDay.day,
                                      );
                                      controller.onPageChanged(newDate);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 18),

                              // Full-width divider
                              Divider(
                                height: 1,
                                color: Colors.grey.shade900,
                                thickness: 1,
                              ),
                              SizedBox(height: 24),

                              // Calendar
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0,
                                    left: 6.0,
                                    right: 6.0,
                                    top: 11.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(91, 38, 38, 38),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TableCalendar<CalendarEvent>(
                                  firstDay: DateTime(2000, 1, 1),
                                  lastDay: DateTime(
                                      DateTime.now().year + 10, 12, 31),
                                  focusedDay: controller.focusedDay,
                                  calendarFormat: controller.calendarFormat,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(controller.selectedDay, day),
                                  onDaySelected: controller.onDaySelected,
                                  onFormatChanged: controller.onFormatChanged,
                                  onPageChanged: controller.onPageChanged,
                                  eventLoader: controller.getEventsForDay,
                                  headerVisible: false,
                                  daysOfWeekHeight: 32,
                                  rowHeight: 45,
                                  calendarStyle: CalendarStyle(
                                    defaultTextStyle:
                                        textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                    ),
                                    weekendTextStyle:
                                        textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                    ),
                                    outsideTextStyle:
                                        textTheme.bodyMedium!.copyWith(
                                      color: const Color.fromARGB(
                                          255, 117, 117, 117),
                                    ),
                                    disabledTextStyle:
                                        textTheme.bodyMedium!.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                    todayTextStyle:
                                        textTheme.bodyMedium!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    selectedTextStyle:
                                        textTheme.bodyMedium!.copyWith(
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
                                    defaultDecoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    weekendDecoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                  ),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle:
                                        textTheme.bodyMedium!.copyWith(
                                      color: const Color.fromARGB(
                                          255, 117, 117, 117),
                                    ),
                                    weekendStyle:
                                        textTheme.bodyMedium!.copyWith(
                                      color: const Color.fromARGB(
                                          255, 117, 117, 117),
                                    ),
                                  ),
                                  calendarBuilders: createCalendarBuilders(
                                      controller: controller),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  EventListWidget(controller: controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _customDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onChanged,
    double? width,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0x90424242)),
        color: Colors.white.withOpacity(0.15),
      ),
      child: DropdownButton2<T>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    labelBuilder(e),
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        style: const TextStyle(color: Colors.white),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color.fromARGB(144, 76, 75, 75)),
            color: Color.fromARGB(255, 49, 48, 48),
          ),
          offset: const Offset(0, -8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        ),
        underline: Container(),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          height: 40,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
