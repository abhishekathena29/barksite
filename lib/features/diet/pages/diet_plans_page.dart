import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/dog_provider.dart';
import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class DietPlansPage extends StatefulWidget {
  const DietPlansPage({super.key});

  @override
  State<DietPlansPage> createState() => _DietPlansPageState();
}

class _DietPlansPageState extends State<DietPlansPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dogProvider = context.watch<DogProvider>();

    if (authProvider.loading || dogProvider.loading) {
      return AppLayout(child: const Center(child: CircularProgressIndicator()));
    }

    final dogProfile = dogProvider.selectedDog;
    final weight = int.tryParse(dogProfile?.weight ?? '50') ?? 50;
    final age = int.tryParse(dogProfile?.age ?? '3') ?? 3;
    final activityLevel = dogProfile?.activityLevel ?? 'moderate';

    double base = weight * 30;
    switch (activityLevel) {
      case 'low':
        base *= 1.2;
        break;
      case 'moderate':
        base *= 1.6;
        break;
      case 'high':
        base *= 2.0;
        break;
      case 'very-high':
        base *= 2.4;
        break;
    }
    if (age < 1) base *= 1.5;
    if (age > 7) base *= 0.9;

    final plans = _buildPlans(base, activityLevel, age, weight);

    return AppLayout(
      title: 'Diet Plans',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dogProfile != null)
            Card(
              color: AppTheme.primary.withValues(alpha: 0.2),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Showing plans for ${dogProfile.name} • ${dogProfile.weight} lbs • $activityLevel activity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
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
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
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
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
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
                  const SizedBox(height: 16),
                  const Text(
                    'Recommended Brands',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: plan.brands
                        .map(
                          (brand) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.muted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              brand,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/food-brands');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'View Food Brands',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
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
    required this.brands,
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
  final List<String> brands;
  final Map<String, String> schedule;
  final bool recommended;
}

List<_DietPlan> _buildPlans(
  double base,
  String activityLevel,
  int age,
  int weight,
) {
  return [
    _DietPlan(
      id: 'balanced',
      name: 'Balanced Nutrition',
      icon: LucideIcons.heart,
      color: const Color(0xFFEF4444),
      description: 'Well-rounded diet for optimal health',
      calories: base.round(),
      protein: '25-30%',
      meals: 2,
      recommended: activityLevel == 'moderate',
      features: [
        'High-quality proteins',
        'Omega fatty acids',
        'Essential vitamins',
        'Prebiotic fiber',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Chicken 18%', 'Turkey 14%', 'Fish 8%'],
        carbs: ['Brown rice', 'Sweet potato', 'Oats'],
        supplements: ['Multivitamin', 'Calcium', 'Probiotics'],
      ),
      brands: [
        'Royal Canin (\$65-75)',
        'Hill\'s Science (\$55-65)',
        'Wellness Core (\$60-70)',
      ],
      schedule: {
        'morning': '7:00-8:00 AM (50%)',
        'evening': '6:00-7:00 PM (50%)',
      },
    ),
    _DietPlan(
      id: 'high-protein',
      name: 'High-Protein Active',
      icon: LucideIcons.dumbbell,
      color: const Color(0xFFF97316),
      description: 'For active dogs needing extra protein',
      calories: (base * 1.1).round(),
      protein: '32-38%',
      meals: 3,
      recommended: activityLevel == 'high' || activityLevel == 'very-high',
      features: [
        'Premium animal protein',
        'Muscle recovery',
        'Joint support',
        'Added electrolytes',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Salmon 22%', 'Turkey 18%', 'Beef 12%'],
        carbs: ['Sweet potato', 'Brown rice', 'Chickpeas'],
        supplements: ['Glucosamine', 'B-vitamins', 'Creatine'],
      ),
      brands: [
        'Orijen (\$85-95)',
        'Merrick Backcountry (\$70-80)',
        'Acana Sport (\$75-85)',
      ],
      schedule: {
        'morning': '6:30-7:30 AM (35%)',
        'midday': '12:00-1:00 PM (30%)',
        'evening': '6:00-7:00 PM (35%)',
      },
    ),
    _DietPlan(
      id: 'senior',
      name: 'Senior Care',
      icon: LucideIcons.brain,
      color: const Color(0xFF8B5CF6),
      description: 'Gentle nutrition for older dogs',
      calories: (base * 0.9).round(),
      protein: '22-26%',
      meals: 2,
      recommended: age > 7,
      features: [
        'Easy to digest',
        'Joint support',
        'Cognitive health',
        'Lower phosphorus',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['White fish 16%', 'Chicken 14%', 'Turkey 10%'],
        carbs: ['White rice', 'Oatmeal', 'Pumpkin'],
        supplements: ['Glucosamine', 'Omega-3', 'Antioxidants'],
      ),
      brands: [
        "Hill's Senior 7+ (\$58-68)",
        'Royal Canin Aging (\$62-72)',
        'Wellness Senior (\$55-65)',
      ],
      schedule: {
        'morning': '7:30-8:30 AM (50%)',
        'evening': '5:30-6:30 PM (50%)',
      },
    ),
    _DietPlan(
      id: 'weight-management',
      name: 'Weight Management',
      icon: LucideIcons.scale,
      color: const Color(0xFF22C55E),
      description: 'Low-calorie for healthy weight loss',
      calories: (base * 0.8).round(),
      protein: '28-32%',
      meals: 3,
      recommended: weight > 80,
      features: [
        'High fiber satiety',
        'L-carnitine',
        'Low glycemic',
        'Lean proteins',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Chicken breast 20%', 'White fish 16%', 'Turkey 12%'],
        carbs: ['Brown rice', 'Steel-cut oats', 'Lentils'],
        supplements: ['L-carnitine', 'Fiber', 'Green tea extract'],
      ),
      brands: [
        'Hill\'s w/d (\$68-78)',
        'Royal Canin Weight (\$65-75)',
        'Purina Pro Weight (\$48-55)',
      ],
      schedule: {
        'morning': '7:00 AM (30%)',
        'midday': '12:00 PM (35%)',
        'evening': '6:00 PM (35%)',
      },
    ),
    _DietPlan(
      id: 'grain-free',
      name: 'Grain-Free',
      icon: LucideIcons.leaf,
      color: const Color(0xFF10B981),
      description: 'For dogs with grain sensitivities',
      calories: base.round(),
      protein: '30-35%',
      meals: 2,
      features: [
        'No grains',
        'Novel proteins',
        'Limited ingredients',
        'Gut health',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Duck 20%', 'Venison 15%', 'Rabbit 10%'],
        carbs: ['Sweet potato', 'Tapioca', 'Chickpeas'],
        supplements: ['Probiotics', 'Digestive enzymes', 'Omega-3'],
      ),
      brands: [
        'Taste of the Wild (\$50-60)',
        'Blue Buffalo Wilderness (\$55-65)',
        'Merrick Grain Free (\$58-68)',
      ],
      schedule: {
        'morning': '7:00-8:00 AM (50%)',
        'evening': '6:00-7:00 PM (50%)',
      },
    ),
    _DietPlan(
      id: 'puppy',
      name: 'Puppy Growth',
      icon: LucideIcons.baby,
      color: const Color(0xFFEC4899),
      description: 'Complete nutrition for growing puppies',
      calories: (base * 1.5).round(),
      protein: '28-32%',
      meals: 4,
      recommended: age < 1,
      features: [
        'DHA brain development',
        'Calcium for bones',
        'Immune support',
        'Digestible proteins',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Chicken 22%', 'Egg 8%', 'Fish meal 6%'],
        carbs: ['Rice', 'Oatmeal', 'Barley'],
        supplements: ['DHA', 'Calcium', 'Colostrum'],
      ),
      brands: [
        'Royal Canin Puppy (\$60-70)',
        "Hill's Puppy (\$55-65)",
        'Wellness Puppy (\$58-68)',
      ],
      schedule: {
        'morning': '7:00 AM (25%)',
        'midday': '12:00 PM (25%)',
        'afternoon': '4:00 PM (25%)',
        'evening': '7:00 PM (25%)',
      },
    ),
    _DietPlan(
      id: 'sensitive-stomach',
      name: 'Sensitive Stomach',
      icon: LucideIcons.activity,
      color: const Color(0xFF14B8A6),
      description: 'Easy digestion for sensitive dogs',
      calories: (base * 0.95).round(),
      protein: '22-26%',
      meals: 3,
      features: [
        'Highly digestible',
        'Limited ingredients',
        'Prebiotics',
        'Gentle proteins',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Lamb 18%', 'White fish 12%', 'Turkey 10%'],
        carbs: ['White rice', 'Pumpkin', 'Sweet potato'],
        supplements: ['Probiotics', 'Fiber', 'Ginger'],
      ),
      brands: [
        "Hill's Sensitive (\$62-72)",
        'Royal Canin Digestive (\$65-75)',
        'Purina Pro Sensitive (\$48-55)',
      ],
      schedule: {
        'morning': '7:30 AM (30%)',
        'midday': '1:00 PM (35%)',
        'evening': '6:30 PM (35%)',
      },
    ),
    _DietPlan(
      id: 'performance',
      name: 'Performance Plus',
      icon: LucideIcons.flame,
      color: const Color(0xFFDC2626),
      description: 'Maximum energy for working dogs',
      calories: (base * 1.3).round(),
      protein: '35-40%',
      meals: 3,
      features: [
        'Energy dense',
        'Quick absorption',
        'Endurance support',
        'Recovery formula',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Beef 25%', 'Chicken 18%', 'Fish 10%'],
        carbs: ['Oats', 'Barley', 'Sweet potato'],
        supplements: ['Electrolytes', 'MCT oil', 'Iron'],
      ),
      brands: [
        'Eukanuba Premium (\$70-80)',
        'Pro Plan Sport (\$55-65)',
        'Victor Performance (\$50-58)',
      ],
      schedule: {
        'morning': '6:00 AM (35%)',
        'midday': '12:00 PM (30%)',
        'evening': '7:00 PM (35%)',
      },
    ),
    _DietPlan(
      id: 'raw-inspired',
      name: 'Raw-Inspired',
      icon: LucideIcons.fish,
      color: const Color(0xFF06B6D4),
      description: 'Mimics ancestral raw diet',
      calories: (base * 1.05).round(),
      protein: '38-42%',
      meals: 2,
      features: [
        'Freeze-dried raw',
        'Whole prey model',
        'Minimal processing',
        'Natural enzymes',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Freeze-dried beef 30%', 'Organ meats 10%', 'Bone meal 5%'],
        carbs: ['Minimal vegetables', 'Berries', 'Leafy greens'],
        supplements: ['Organ blend', 'Kelp', 'Bone broth'],
      ),
      brands: [
        "Stella & Chewy's (\$75-90)",
        'Primal (\$70-85)',
        'Instinct Raw (\$65-80)',
      ],
      schedule: {
        'morning': '7:00-8:00 AM (50%)',
        'evening': '6:00-7:00 PM (50%)',
      },
    ),
    _DietPlan(
      id: 'joint-health',
      name: 'Joint and Mobility',
      icon: LucideIcons.bone,
      color: const Color(0xFFF59E0B),
      description: 'Support for joints and mobility',
      calories: (base * 0.95).round(),
      protein: '26-30%',
      meals: 2,
      features: [
        'Glucosamine rich',
        'Chondroitin',
        'Anti-inflammatory',
        'Omega-3 EPA/DHA',
      ],
      mealInclusions: _MealInclusions(
        proteins: ['Salmon 20%', 'Chicken 15%', 'Mussels 5%'],
        carbs: ['Brown rice', 'Sweet potato', 'Quinoa'],
        supplements: [
          'Glucosamine 1200mg',
          'Chondroitin 800mg',
          'MSM',
          'Turmeric',
        ],
      ),
      brands: [
        "Hill's Joint Care (\$65-75)",
        'Royal Canin Mobility (\$68-78)',
        'Blue Buffalo Joint (\$55-65)',
      ],
      schedule: {
        'morning': '7:30-8:30 AM (50%)',
        'evening': '6:00-7:00 PM (50%)',
      },
    ),
  ];
}
