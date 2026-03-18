import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WeeklyCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const WeeklyCalendar({super.key, required this.onDateSelected});

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {CalendarFormat.week: 'Week'},

      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },

      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          widget.onDateSelected(selectedDay);
        }
      },

      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.green.shade200,
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.indigo,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        todayTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
