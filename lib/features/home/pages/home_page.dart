import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/dog_profile.dart';
import '../../../models/schedule_item.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dog_provider.dart';
import '../../../providers/schedule_provider.dart';
import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _deleteDog(DogProfile dog) async {
    await context.read<DogProvider>().deleteDog(dog.id);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${dog.name} removed')));
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dogProvider = context.watch<DogProvider>();
    final scheduleProvider = context.watch<ScheduleProvider>();

    if (authProvider.loading || dogProvider.loading) {
      return const AppLayout(child: Center(child: CircularProgressIndicator()));
    }

    final user = authProvider.currentUser!;
    final dogs = dogProvider.dogs;
    final selectedDog = dogProvider.selectedDog;
    final upcoming = scheduleProvider.upcomingItems(limit: 4);

    return AppLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(
              userName: user.name,
              dogs: dogs,
              selectedDog: selectedDog,
              onLogout: _logout,
              onSelectDog: (dogId) =>
                  context.read<DogProvider>().selectDog(dogId),
              onManageProfile: () => Navigator.pushNamed(context, '/account'),
            ),
            const SizedBox(height: 18),
            if (dogs.isEmpty)
              _EmptyDogsCard(
                onAddDog: () => Navigator.pushNamed(context, '/profile'),
              )
            else ...[
              _DogSummaryCard(
                dog: selectedDog!,
                onEdit: () => Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: selectedDog,
                ),
                onDelete: () => _deleteDog(selectedDog),
              ),
              const SizedBox(height: 18),
              _SectionHeader(
                title: 'Quick Actions',
                actionLabel: 'Add Dog',
                onAction: () => Navigator.pushNamed(context, '/profile'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _QuickActionCard(
                    title: 'Calendar',
                    subtitle: 'Plan meals and walks',
                    icon: LucideIcons.calendarDays,
                    color: AppTheme.accent,
                    onTap: () => Navigator.pushNamed(context, '/calendar'),
                  ),
                  const SizedBox(width: 12),
                  _QuickActionCard(
                    title: 'Diet Plan',
                    subtitle: 'Nutrition for ${selectedDog.name}',
                    icon: LucideIcons.utensils,
                    color: AppTheme.primary,
                    onTap: () => Navigator.pushNamed(context, '/diet-plans'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _WideActionCard(
                title: 'Find stores and parks',
                subtitle:
                    'Search places that fit ${selectedDog.name}\'s routine',
                icon: LucideIcons.mapPin,
                onTap: () => Navigator.pushNamed(context, '/map'),
              ),
              const SizedBox(height: 18),
              _SectionHeader(
                title: 'Upcoming for ${selectedDog.name}',
                actionLabel: 'Open Calendar',
                onAction: () => Navigator.pushNamed(context, '/calendar'),
              ),
              const SizedBox(height: 12),
              if (scheduleProvider.loading)
                const Center(child: CircularProgressIndicator())
              else if (upcoming.isEmpty)
                _EmptyAgendaCard(
                  dogName: selectedDog.name,
                  onCreateSchedule: () =>
                      Navigator.pushNamed(context, '/calendar'),
                )
              else
                ...upcoming.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AgendaCard(item: item),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.userName,
    required this.dogs,
    required this.selectedDog,
    required this.onLogout,
    required this.onSelectDog,
    required this.onManageProfile,
  });

  final String userName;
  final List<DogProfile> dogs;
  final DogProfile? selectedDog;
  final VoidCallback onLogout;
  final ValueChanged<String> onSelectDog;
  final VoidCallback onManageProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2F6B5F), Color(0xFF275248)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
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
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onManageProfile,
                icon: const Icon(LucideIcons.settings2, color: Colors.white),
              ),
              IconButton(
                onPressed: onLogout,
                icon: const Icon(LucideIcons.logOut, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (dogs.isEmpty)
            const Text(
              'Create your first dog profile to unlock personalized diet plans, reminders, and place suggestions.',
              style: TextStyle(color: Colors.white, height: 1.5),
            )
          else ...[
            Row(
              children: [
                const Icon(LucideIcons.dog, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Currently focused on',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDog?.id,
                  dropdownColor: AppTheme.foreground,
                  iconEnabledColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  items: dogs
                      .map(
                        (dog) => DropdownMenuItem<String>(
                          value: dog.id,
                          child: Text('${dog.name} • ${dog.breed}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onSelectDog(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _HeroPill(
                  label: '${dogs.length} dog profiles',
                  icon: LucideIcons.badgeInfo,
                ),
                if (selectedDog != null)
                  _HeroPill(
                    label: '${selectedDog!.activityLevel} activity',
                    icon: LucideIcons.activity,
                  ),
                if (selectedDog != null)
                  _HeroPill(
                    label: '${selectedDog!.weight} lbs',
                    icon: LucideIcons.scale,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _EmptyDogsCard extends StatelessWidget {
  const _EmptyDogsCard({required this.onAddDog});

  final VoidCallback onAddDog;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.dog,
                size: 34,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Build the app around your dog',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add your dog once and the home feed, diet plans, calendar, and other suggestions will adjust to that profile.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.mutedText, height: 1.5),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onAddDog,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Create First Dog Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DogSummaryCard extends StatelessWidget {
  const _DogSummaryCard({
    required this.dog,
    required this.onEdit,
    required this.onDelete,
  });

  final DogProfile dog;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.dog,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dog.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dog.breed} • ${dog.age} years • ${dog.weight} lbs',
                        style: const TextStyle(color: AppTheme.mutedText),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit profile')),
                    PopupMenuItem(value: 'delete', child: Text('Delete dog')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoChip(
                  label: 'Gender',
                  value: dog.gender.isEmpty ? 'Not set' : dog.gender,
                ),
                _InfoChip(label: 'Activity', value: dog.activityLevel),
                _InfoChip(
                  label: 'Food',
                  value: dog.foodPreference.isEmpty
                      ? 'No preference'
                      : dog.foodPreference,
                ),
                _InfoChip(
                  label: 'Allergies',
                  value: dog.allergies.isEmpty ? 'None noted' : dog.allergies,
                ),
              ],
            ),
            if (dog.healthConditions.isNotEmpty || dog.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.muted,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dog.healthConditions.isNotEmpty)
                      Text(
                        'Health: ${dog.healthConditions}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    if (dog.healthConditions.isNotEmpty && dog.notes.isNotEmpty)
                      const SizedBox(height: 6),
                    if (dog.notes.isNotEmpty)
                      Text(
                        'Notes: ${dog.notes}',
                        style: const TextStyle(color: AppTheme.mutedText),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.muted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WideActionCard extends StatelessWidget {
  const _WideActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.highlight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(LucideIcons.mapPin, color: AppTheme.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppTheme.mutedText),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppTheme.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}

class _EmptyAgendaCard extends StatelessWidget {
  const _EmptyAgendaCard({
    required this.dogName,
    required this.onCreateSchedule,
  });

  final String dogName;
  final VoidCallback onCreateSchedule;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'No schedule yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Start planning meals, medication, walks, or grooming for $dogName.',
              style: const TextStyle(color: AppTheme.mutedText),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCreateSchedule,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Create Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({required this.item});

  final ScheduleItem item;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(item.startsAt),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _typeColor(item.type).withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_typeIcon(item.type), color: _typeColor(item.type)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.type.toUpperCase()} • $time',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            if (item.isCompleted)
              const Icon(LucideIcons.badgeCheck, color: AppTheme.accent),
          ],
        ),
      ),
    );
  }
}

Color _typeColor(String type) {
  switch (type) {
    case 'walk':
      return const Color(0xFF2F6B5F);
    case 'medicine':
      return const Color(0xFF7856D8);
    case 'grooming':
      return const Color(0xFFB25F2D);
    default:
      return AppTheme.primary;
  }
}

IconData _typeIcon(String type) {
  switch (type) {
    case 'walk':
      return LucideIcons.mapPin;
    case 'medicine':
      return LucideIcons.alertCircle;
    case 'grooming':
      return LucideIcons.scissors;
    default:
      return LucideIcons.utensils;
  }
}
