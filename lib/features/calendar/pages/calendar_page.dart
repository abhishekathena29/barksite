import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final List<_Event> _events = [
    _Event('Morning Feeding', '7:00 AM', LucideIcons.utensils, const Color(0xFFF97316)),
    _Event('Vitamin Supplement', '8:00 AM', Icons.medication, const Color(0xFF22C55E)),
    _Event('Evening Walk', '5:00 PM', LucideIcons.clock, const Color(0xFF3B82F6)),
    _Event('Evening Feeding', '6:30 PM', LucideIcons.utensils, const Color(0xFFF97316)),
    _Event('Grooming Appointment', 'Sat, 10:00 AM', LucideIcons.scissors, const Color(0xFF8B5CF6)),
  ];

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(_selectedDay, DateTime.now());
    return AppLayout(
      title: 'Calendar',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => DateUtils.isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.3), shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isToday ? "Today's Schedule" : 'Schedule for ${_selectedDay.month}/${_selectedDay.day}/${_selectedDay.year}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
                          child: Icon(event.icon, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(event.time, style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppTheme.primary.withOpacity(0.06),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Tap on a date to add feeding schedules and reminders.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Event {
  const _Event(this.title, this.time, this.icon, this.color);
  final String title;
  final String time;
  final IconData icon;
  final Color color;
}
