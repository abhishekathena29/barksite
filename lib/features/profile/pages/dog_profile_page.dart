import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/dog_profile.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dog_provider.dart';
import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class DogProfilePage extends StatefulWidget {
  const DogProfilePage({super.key});

  @override
  State<DogProfilePage> createState() => _DogProfilePageState();
}

class _DogProfilePageState extends State<DogProfilePage> {
  int _step = 1;

  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _healthController = TextEditingController();
  String _activityLevel = '';

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _healthController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 1 && (_nameController.text.trim().isEmpty || _breedController.text.trim().isEmpty)) {
      _showSnack('Please fill in all fields', isError: true);
      return;
    }
    if (_step == 2 && (_ageController.text.trim().isEmpty || _weightController.text.trim().isEmpty)) {
      _showSnack('Please fill in all fields', isError: true);
      return;
    }
    setState(() => _step += 1);
  }

  Future<void> _submit() async {
    if (_activityLevel.isEmpty) {
      _showSnack('Please select an activity level', isError: true);
      return;
    }
    final authProvider = context.read<AuthProvider>();
    final dogProvider = context.read<DogProvider>();
    final user = authProvider.currentUser;
    if (user == null) {
      _showSnack('Please log in first', isError: true);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final dog = DogProfile(
      id: '',
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      age: _ageController.text.trim(),
      weight: _weightController.text.trim(),
      activityLevel: _activityLevel,
      healthConditions: _healthController.text.trim(),
    );

    final created = await dogProvider.addDog(dog);
    if (created == null) {
      _showSnack(dogProvider.error ?? 'Unable to add dog', isError: true);
      return;
    }
    if (!mounted) return;
    _showSnack('${dog.name} added');
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.destructive : AppTheme.foreground,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Column(
        children: [
          Column(
            children: const [
              _HeroIcon(),
              SizedBox(height: 8),
              Text('Add a Dog', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text('Tell us about your furry friend', style: TextStyle(fontSize: 12, color: AppTheme.mutedText)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final stepIndex = index + 1;
              final isActive = stepIndex == _step;
              final isPast = stepIndex < _step;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 30,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.primary : isPast ? AppTheme.primary.withOpacity(0.5) : AppTheme.muted,
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildStep(),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppTheme.primary.withOpacity(0.06),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Tip: Accurate information helps us create the perfect diet plan for your dog.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1:
        return _StepCard(
          key: const ValueKey('step1'),
          title: 'Basic Information',
          icon: LucideIcons.sparkles,
          child: Column(
            children: [
              _LabeledField(
                label: "Dog's Name",
                icon: LucideIcons.dog,
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'e.g., Max, Bella'),
                ),
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Breed',
                icon: LucideIcons.heart,
                child: TextField(
                  controller: _breedController,
                  decoration: const InputDecoration(hintText: 'e.g., Golden Retriever'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _next,
                  icon: const Icon(LucideIcons.arrowRight, size: 18),
                  label: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        );
      case 2:
        return _StepCard(
          key: const ValueKey('step2'),
          title: 'Physical Details',
          icon: LucideIcons.scale,
          child: Column(
            children: [
              _LabeledField(
                label: 'Age (years)',
                icon: LucideIcons.clock,
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'e.g., 3'),
                ),
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Weight (lbs)',
                icon: LucideIcons.activity,
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'e.g., 65'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _step = 1),
                      icon: const Icon(LucideIcons.arrowLeft, size: 18),
                      label: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _next,
                      icon: const Icon(LucideIcons.arrowRight, size: 18),
                      label: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case 3:
      default:
        return _StepCard(
          key: const ValueKey('step3'),
          title: 'Activity and Health',
          icon: LucideIcons.activity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Activity Level', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _ActivityOption(value: 'low', label: 'Low', description: 'Mostly indoor, minimal exercise', icon: 'Sofa'),
                  _ActivityOption(value: 'moderate', label: 'Moderate', description: 'Regular walks, some play time', icon: 'Walk'),
                  _ActivityOption(value: 'high', label: 'High', description: 'Daily runs, very active', icon: 'Run'),
                  _ActivityOption(value: 'very-high', label: 'Very High', description: 'Working dog, intense activity', icon: 'Bolt'),
                ],
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Health Conditions (Optional)',
                icon: LucideIcons.alertCircle,
                child: TextField(
                  controller: _healthController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Any allergies or dietary restrictions...'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _step = 2),
                      icon: const Icon(LucideIcons.arrowLeft, size: 18),
                      label: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(LucideIcons.sparkles, size: 18),
                      label: const Text('Add Dog', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 6))
        ],
      ),
      child: const Icon(LucideIcons.dog, color: Colors.white, size: 36),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({super.key, required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.primary.withOpacity(0.2), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.icon, required this.child});

  final String label;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.primary),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _ActivityOption extends StatefulWidget {
  const _ActivityOption({required this.value, required this.label, required this.description, required this.icon});

  final String value;
  final String label;
  final String description;
  final String icon;

  @override
  State<_ActivityOption> createState() => _ActivityOptionState();
}

class _ActivityOptionState extends State<_ActivityOption> {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_DogProfilePageState>();
    final isSelected = state?._activityLevel == widget.value;

    return GestureDetector(
      onTap: () {
        state?.setState(() => state._activityLevel = widget.value);
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 2,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.icon, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(widget.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(widget.description, style: const TextStyle(fontSize: 11, color: AppTheme.mutedText, height: 1.3)),
          ],
        ),
      ),
    );
  }
}
