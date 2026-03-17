import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/dog_profile.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dog_provider.dart';
import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _deleteDog(DogProfile dog) async {
    final dogProvider = context.read<DogProvider>();
    await dogProvider.deleteDog(dog.id);
    if (!mounted) return;
    _showSnack('${dog.name} removed');
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.foreground),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dogProvider = context.watch<DogProvider>();

    if (authProvider.loading) {
      return AppLayout(child: const Center(child: CircularProgressIndicator()));
    }

    final user = authProvider.currentUser!;
    final dogs = dogProvider.dogs;
    final loadingDogs = dogProvider.loading;

    return AppLayout(
      child: loadingDogs
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${user.name.split(' ').first}!',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Your dog nutrition companion',
                            style: TextStyle(
                              color: AppTheme.mutedText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _logout,
                        icon: const Icon(
                          LucideIcons.logOut,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Dogs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/profile'),
                        icon: const Icon(LucideIcons.plus, size: 16),
                        label: const Text('Add Dog'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (dogs.isEmpty)
                    Card(
                      color: AppTheme.primary.withOpacity(0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LucideIcons.dog,
                                color: AppTheme.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'No dogs added yet. Add your first furry friend!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.mutedText),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/profile'),
                              icon: const Icon(LucideIcons.plus, size: 16),
                              label: const Text('Add Your First Dog'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: dogs
                          .map(
                            (dog) => Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.primary,
                                            AppTheme.accent,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        LucideIcons.dog,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dog.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${dog.breed} • ${dog.age}y • ${dog.weight} lbs',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.mutedText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteDog(dog),
                                      icon: const Icon(
                                        LucideIcons.trash2,
                                        color: AppTheme.mutedText,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 18),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _QuickAction(
                        label: 'Find Pet Stores',
                        icon: LucideIcons.mapPin,
                        color: const Color(0xFF3B82F6),
                        onTap: () => Navigator.pushNamed(context, '/map'),
                      ),
                      _QuickAction(
                        label: 'Diet Plans',
                        icon: LucideIcons.utensils,
                        color: const Color(0xFFF97316),
                        onTap: () =>
                            Navigator.pushNamed(context, '/diet-plans'),
                      ),
                      _QuickAction(
                        label: 'Schedule',
                        icon: LucideIcons.calendar,
                        color: const Color(0xFF22C55E),
                        onTap: () => Navigator.pushNamed(context, '/calendar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Diet Plans',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/diet-plans'),
                        child: Row(
                          children: const [
                            Text(
                              'View All',
                              style: TextStyle(color: AppTheme.primary),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: [
                      _PlanTile(title: 'Balanced Nutrition'),
                      _PlanTile(title: 'High-Protein Active'),
                      _PlanTile(title: 'Weight Management'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
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
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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

class _PlanTile extends StatelessWidget {
  const _PlanTile({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE9D6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.utensils,
                size: 18,
                color: Color(0xFFCC6B2C),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: AppTheme.mutedText,
            ),
          ],
        ),
      ),
    );
  }
}
