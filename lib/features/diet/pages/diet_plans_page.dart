import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/dog_profile.dart';
import '../../../providers/dog_provider.dart';
import '../../../services/gemini_service.dart';
import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class DietPlansPage extends StatefulWidget {
  const DietPlansPage({super.key});

  @override
  State<DietPlansPage> createState() => _DietPlansPageState();
}

class _DietPlansPageState extends State<DietPlansPage> {
  Future<List<_DietPlan>>? _plansFuture;
  String? _loadedForDogId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dog = context.read<DogProvider>().selectedDog;
    if (dog != null && dog.id != _loadedForDogId) {
      _loadedForDogId = dog.id;
      _plansFuture = _fetchPlans(dog);
    }
  }

  Future<List<_DietPlan>> _fetchPlans(DogProfile dog) async {
    final raw = await GeminiService.generateDietPlans(
      dogName: dog.name,
      breed: dog.breed,
      age: dog.age,
      weight: dog.weight,
      activityLevel: dog.activityLevel,
      healthConditions: dog.healthConditions,
      allergies: dog.allergies,
      foodPreference: dog.foodPreference,
      notes: dog.notes,
    );
    return raw.asMap().entries.map((e) => _parsePlan(e.value, e.key)).toList();
  }

  static _DietPlan _parsePlan(Map<String, dynamic> m, int index) {
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFF8B5CF6),
      const Color(0xFF22C55E),
      const Color(0xFF10B981),
      const Color(0xFFEC4899),
      const Color(0xFF14B8A6),
      const Color(0xFFDC2626),
    ];
    final icons = [
      LucideIcons.heart,
      LucideIcons.dumbbell,
      LucideIcons.brain,
      LucideIcons.scale,
      LucideIcons.leaf,
      LucideIcons.baby,
      LucideIcons.activity,
      LucideIcons.flame,
    ];

    final scheduleRaw = m['schedule'] as Map<String, dynamic>? ?? {};
    final schedule = scheduleRaw.map((k, v) => MapEntry(k, v.toString()));

    return _DietPlan(
      id: m['id']?.toString() ?? 'plan_$index',
      name: m['name']?.toString() ?? 'Diet Plan ${index + 1}',
      icon: icons[index % icons.length],
      color: colors[index % colors.length],
      description: m['description']?.toString() ?? '',
      calories: (m['calories'] as num?)?.toInt() ?? 1200,
      protein: m['protein']?.toString() ?? '25-30%',
      meals: (m['meals'] as num?)?.toInt() ?? 2,
      recommended: m['recommended'] == true,
      features: List<String>.from(m['features'] as List? ?? []),
      mealInclusions: _MealInclusions(
        proteins: List<String>.from(m['proteins'] as List? ?? []),
        carbs: List<String>.from(m['carbs'] as List? ?? []),
        supplements: List<String>.from(m['supplements'] as List? ?? []),
      ),
      schedule: schedule,
    );
  }

  void _retry(DogProfile dog) {
    setState(() {
      _loadedForDogId = null;
      _plansFuture = null;
    });
    _loadedForDogId = dog.id;
    setState(() {
      _plansFuture = _fetchPlans(dog);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dogProvider = context.watch<DogProvider>();
    final dogProfile = dogProvider.selectedDog;

    if (dogProfile == null) {
      return AppLayout(
        title: 'Diet Plans',
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Please add a dog profile first to see personalized diet plans.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.mutedText, fontSize: 15),
            ),
          ),
        ),
      );
    }

    return AppLayout(
      title: 'Diet Plans',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: AppTheme.primary.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(LucideIcons.sparkles, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI-generated plans for ${dogProfile.name} • ${dogProfile.weight} kg • ${dogProfile.activityLevel} activity',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<_DietPlan>>(
              future: _plansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text(
                        'Generating personalized Indian diet plans...',
                        style: TextStyle(color: AppTheme.mutedText),
                      ),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.alertCircle,
                            color: AppTheme.destructive,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Failed to generate diet plans',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.mutedText,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _retry(dogProfile),
                            icon: const Icon(LucideIcons.refreshCw, size: 16),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final plans = snapshot.data ?? [];

                return ListView.separated(
                  itemCount: plans.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return GestureDetector(
                      onTap: () => _openPlanSheet(plan),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: plan.recommended
                                ? AppTheme.primary
                                : AppTheme.border,
                            width: plan.recommended ? 2 : 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: plan.color,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  plan.icon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            plan.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        if (plan.recommended)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            child: const Text(
                                              'Recommended',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      plan.description,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.mutedText,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          '${plan.calories} cal/day',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.mutedText,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          '•',
                                          style: TextStyle(
                                            color: AppTheme.mutedText,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${plan.protein} protein',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.mutedText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openPlanSheet(_DietPlan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.92,
          initialChildSize: 0.85,
          minChildSize: 0.6,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: plan.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(plan.icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _StatBox(
                        label: 'Calories/day',
                        value: plan.calories.toString(),
                      ),
                      _StatBox(label: 'Protein', value: plan.protein),
                      _StatBox(
                        label: 'Meals/day',
                        value: plan.meals.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Key Features',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: plan.features
                        .map(
                          (feature) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.muted,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              feature,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Meal Composition',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _MealBox(
                    title: 'Proteins',
                    items: plan.mealInclusions.proteins,
                    color: const Color(0xFFFFF1E6),
                  ),
                  _MealBox(
                    title: 'Carbohydrates',
                    items: plan.mealInclusions.carbs,
                    color: const Color(0xFFFFF6D9),
                  ),
                  _MealBox(
                    title: 'Supplements',
                    items: plan.mealInclusions.supplements,
                    color: const Color(0xFFEAF7EC),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Feeding Schedule',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: plan.schedule.entries
                        .map(
                          (entry) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.muted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _capitalize(entry.key),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.muted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppTheme.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealBox extends StatelessWidget {
  const _MealBox({
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            items.join(' • '),
            style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
          ),
        ],
      ),
    );
  }
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

class _MealInclusions {
  _MealInclusions({
    required this.proteins,
    required this.carbs,
    required this.supplements,
  });
  final List<String> proteins;
  final List<String> carbs;
  final List<String> supplements;
}

class _DietPlan {
  _DietPlan({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.calories,
    required this.protein,
    required this.meals,
    required this.features,
    required this.mealInclusions,
    required this.schedule,
    this.recommended = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final int calories;
  final String protein;
  final int meals;
  final List<String> features;
  final _MealInclusions mealInclusions;
  final Map<String, String> schedule;
  final bool recommended;
}
