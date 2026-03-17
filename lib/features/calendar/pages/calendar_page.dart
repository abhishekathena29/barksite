import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/schedule_item.dart';
import '../../../providers/dog_provider.dart';
import '../../../providers/schedule_provider.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.week;

  Future<void> _openCreateSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CreateScheduleSheet(),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Schedule saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dogProvider = context.watch<DogProvider>();
    final scheduleProvider = context.watch<ScheduleProvider>();
    final dog = dogProvider.selectedDog;
    final events = scheduleProvider.itemsForDay(_selectedDay);

    return AppLayout(
      title: 'Calendar',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dog == null
                                    ? 'Pick a dog first'
                                    : '${dog.name}\'s planner',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                dog == null
                                    ? 'Create a dog profile to plan meals, medications, walks, and grooming.'
                                    : 'Plan the week, review upcoming tasks, and keep everything centered on ${dog.name}.',
                                style: const TextStyle(
                                  color: AppTheme.mutedText,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: dog == null ? null : _openCreateSheet,
                          icon: const Icon(LucideIcons.plus),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SegmentedButton<CalendarFormat>(
                      segments: const [
                        ButtonSegment(
                          value: CalendarFormat.week,
                          icon: Icon(LucideIcons.calendar),
                          label: Text('Week'),
                        ),
                        ButtonSegment(
                          value: CalendarFormat.month,
                          icon: Icon(LucideIcons.calendar),
                          label: Text('Month'),
                        ),
                      ],
                      selected: {_calendarFormat},
                      onSelectionChanged: (selection) {
                        setState(() => _calendarFormat = selection.first);
                      },
                    ),
                    const SizedBox(height: 14),
                    TableCalendar<ScheduleItem>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2032, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      availableCalendarFormats: const {
                        CalendarFormat.week: 'Week',
                        CalendarFormat.month: 'Month',
                      },
                      eventLoader: scheduleProvider.itemsForDay,
                      selectedDayPredicate: (day) =>
                          DateUtils.isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() => _calendarFormat = format);
                      },
                      calendarStyle: CalendarStyle(
                        markerDecoration: const BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _DaySummaryCard(
              selectedDay: _selectedDay,
              itemCount: events.length,
              dogName: dog?.name,
            ),
            const SizedBox(height: 18),
            if (dog == null)
              _NoDogCard(
                onAddDog: () => Navigator.pushNamed(context, '/profile'),
              )
            else if (scheduleProvider.loading)
              const Center(child: CircularProgressIndicator())
            else if (events.isEmpty)
              _EmptyScheduleCard(onCreateSchedule: _openCreateSheet)
            else
              ...events.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ScheduleTile(item: item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DaySummaryCard extends StatelessWidget {
  const _DaySummaryCard({
    required this.selectedDay,
    required this.itemCount,
    required this.dogName,
  });

  final DateTime selectedDay;
  final int itemCount;
  final String? dogName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(LucideIcons.calendar, color: AppTheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dogName == null
                        ? 'No dog selected yet'
                        : '$itemCount items scheduled for $dogName',
                    style: const TextStyle(color: AppTheme.mutedText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.item});

  final ScheduleItem item;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ScheduleProvider>();
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(item.startsAt));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: item.isCompleted,
              onChanged: (_) => provider.toggleCompleted(item),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.type.toUpperCase()} • $time • ${item.durationMinutes} min',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  if (item.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.notes,
                      style: const TextStyle(color: AppTheme.mutedText),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => provider.deleteItem(item.id),
              icon: const Icon(LucideIcons.trash2, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyScheduleCard extends StatelessWidget {
  const _EmptyScheduleCard({required this.onCreateSchedule});

  final VoidCallback onCreateSchedule;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'No schedule for this day',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add feeding times, medication, walks, or grooming to build a real routine.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.mutedText, height: 1.5),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCreateSchedule,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Add schedule item'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoDogCard extends StatelessWidget {
  const _NoDogCard({required this.onAddDog});

  final VoidCallback onAddDog;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(LucideIcons.dog, size: 34, color: AppTheme.primary),
            const SizedBox(height: 12),
            const Text(
              'Add a dog to start scheduling',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text(
              'Calendar items are stored under each dog, so every routine stays separate and personalized.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.mutedText, height: 1.5),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddDog,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Create dog profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateScheduleSheet extends StatefulWidget {
  const _CreateScheduleSheet();

  @override
  State<_CreateScheduleSheet> createState() => _CreateScheduleSheetState();
}

class _CreateScheduleSheetState extends State<_CreateScheduleSheet> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  String _type = 'meal';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: _date,
    );
    if (result == null) return;
    setState(() => _date = result);
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(context: context, initialTime: _time);
    if (result == null) return;
    setState(() => _time = result);
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;

    final scheduled = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );

    setState(() => _saving = true);
    final success = await context.read<ScheduleProvider>().addItem(
      ScheduleItem(
        id: '',
        title: _titleController.text.trim(),
        type: _type,
        dateTime: scheduled.toIso8601String(),
        notes: _notesController.text.trim(),
        durationMinutes: int.tryParse(_durationController.text.trim()) ?? 30,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final localizations = MaterialLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New schedule item',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(LucideIcons.pencil),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                prefixIcon: Icon(LucideIcons.badgeInfo),
              ),
              items: const [
                DropdownMenuItem(value: 'meal', child: Text('Meal')),
                DropdownMenuItem(value: 'walk', child: Text('Walk')),
                DropdownMenuItem(value: 'medicine', child: Text('Medicine')),
                DropdownMenuItem(value: 'grooming', child: Text('Grooming')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(LucideIcons.calendarDays),
                    label: Text('${_date.day}/${_date.month}/${_date.year}'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(LucideIcons.clock3),
                    label: Text(localizations.formatTimeOfDay(_time)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                prefixIcon: Icon(LucideIcons.timer),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                prefixIcon: Icon(LucideIcons.alertCircle),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(LucideIcons.save),
                label: Text(_saving ? 'Saving...' : 'Save item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
