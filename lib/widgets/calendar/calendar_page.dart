// calendar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
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
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  late List<int> _years;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    _years = List.generate(currentYear - 1999, (index) => 2000 + index);
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
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Card(
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.grey[800]!, width: 2),
                    ),
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          // Month/Year selector row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Month dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[700]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: currentMonth,
                                    items: _months.asMap().entries.map((entry) {
                                      return DropdownMenuItem<int>(
                                        value: entry.key,
                                        child: Text(
                                          entry.value,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (int? newMonth) {
                                      if (newMonth != null) {
                                        final newDate = DateTime(
                                          controller.focusedDay.year,
                                          newMonth + 1,
                                          controller.focusedDay.day,
                                        );
                                        controller.onPageChanged(newDate);
                                      }
                                    },
                                    dropdownColor: Colors.grey[900],
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              
                              // Year dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[700]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: currentYear,
                                    items: _years.map((year) {
                                      return DropdownMenuItem<int>(
                                        value: year,
                                        child: Text(
                                          year.toString(),
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (int? newYear) {
                                      if (newYear != null) {
                                        final newDate = DateTime(
                                          newYear,
                                          controller.focusedDay.month,
                                          controller.focusedDay.day,
                                        );
                                        controller.onPageChanged(newDate);
                                      }
                                    },
                                    dropdownColor: Colors.grey[900],
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          
                          // Full-width divider
                          Divider(
                            height: 1,
                            color: Colors.grey[800],
                            thickness: 1,
                          ),
                          SizedBox(height: 12),
                          
                          // Calendar
                          TableCalendar<CalendarEvent>(
                            firstDay: DateTime(2000, 1, 1),
                            lastDay: DateTime(DateTime.now().year + 10, 12, 31),
                            focusedDay: controller.focusedDay,
                            calendarFormat: controller.calendarFormat,
                            selectedDayPredicate: (day) =>
                                isSameDay(controller.selectedDay, day),
                            onDaySelected: controller.onDaySelected,
                            onFormatChanged: controller.onFormatChanged,
                            onPageChanged: controller.onPageChanged,
                            eventLoader: controller.getEventsForDay,
                            headerVisible: false,
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                              weekendTextStyle: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                              outsideTextStyle: textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                              ),
                              disabledTextStyle: textTheme.bodyMedium!.copyWith(
                                color: Colors.grey[600],
                              ),
                              todayTextStyle: textTheme.bodyMedium!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              selectedTextStyle: textTheme.bodyMedium!.copyWith(
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
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                              weekendStyle: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            calendarBuilders: createCalendarBuilders(
                              controller: controller
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: EventListWidget(controller: controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}