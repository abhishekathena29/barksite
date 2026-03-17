import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/dog_profile.dart';
import '../../../providers/dog_provider.dart';
import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class DogProfilePage extends StatefulWidget {
  const DogProfilePage({super.key});

  @override
  State<DogProfilePage> createState() => _DogProfilePageState();
}

class _DogProfilePageState extends State<DogProfilePage> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _healthController = TextEditingController();
  final _foodController = TextEditingController();
  final _notesController = TextEditingController();

  String _gender = 'Male';
  String _activityLevel = 'Moderate';
  bool _saving = false;
  DogProfile? _editingDog;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    final dog = ModalRoute.of(context)?.settings.arguments;
    if (dog is DogProfile) {
      _editingDog = dog;
      _nameController.text = dog.name;
      _breedController.text = dog.breed;
      _ageController.text = dog.age;
      _weightController.text = dog.weight;
      _birthdayController.text = dog.birthday;
      _allergiesController.text = dog.allergies;
      _healthController.text = dog.healthConditions;
      _foodController.text = dog.foodPreference;
      _notesController.text = dog.notes;
      _gender = dog.gender.isEmpty ? 'Male' : dog.gender;
      _activityLevel = dog.activityLevel.isEmpty
          ? 'Moderate'
          : _capitalize(dog.activityLevel);
    }
    _loaded = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _birthdayController.dispose();
    _allergiesController.dispose();
    _healthController.dispose();
    _foodController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final initial =
        DateTime.tryParse(_birthdayController.text) ?? DateTime(now.year - 2);
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDate: initial,
    );
    if (result == null) return;
    _birthdayController.text = result.toIso8601String().split('T').first;
    setState(() {});
  }

  Future<void> _saveDog() async {
    if (_nameController.text.trim().isEmpty ||
        _breedController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
        _weightController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in the basic dog details first')),
      );
      return;
    }

    final provider = context.read<DogProvider>();
    final dog = DogProfile(
      id: _editingDog?.id ?? '',
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      age: _ageController.text.trim(),
      weight: _weightController.text.trim(),
      activityLevel: _activityLevel.toLowerCase(),
      healthConditions: _healthController.text.trim(),
      gender: _gender,
      birthday: _birthdayController.text.trim(),
      allergies: _allergiesController.text.trim(),
      foodPreference: _foodController.text.trim(),
      notes: _notesController.text.trim(),
      createdAt: _editingDog?.createdAt ?? '',
    );

    setState(() => _saving = true);
    final success = _editingDog == null
        ? await provider.addDog(dog) != null
        : await provider.updateDog(dog);

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (_editingDog == null
                    ? '${dog.name} profile created'
                    : '${dog.name} profile updated')
              : (provider.error ?? 'Unable to save dog profile'),
        ),
      ),
    );

    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingDog != null;

    return AppLayout(
      title: isEditing ? 'Edit Dog Profile' : 'Add Dog Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                                isEditing
                                    ? 'Refine the profile'
                                    : 'Create a complete dog profile',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'This profile powers the home feed, schedule planning, and personalized diet guidance.',
                                style: TextStyle(
                                  color: AppTheme.mutedText,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _MiniTag(label: 'Firestore synced'),
                        _MiniTag(label: 'Dog-specific experience'),
                        _MiniTag(label: 'Editable anytime'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _FormSection(
              title: 'Basic details',
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Dog name',
                      prefixIcon: Icon(LucideIcons.star),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _breedController,
                    decoration: const InputDecoration(
                      labelText: 'Breed',
                      prefixIcon: Icon(LucideIcons.heart),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Age (years)',
                            prefixIcon: Icon(LucideIcons.clock),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight (lbs)',
                            prefixIcon: Icon(LucideIcons.scale),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(LucideIcons.user),
                          ),
                          items: const ['Male', 'Female']
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _gender = value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _birthdayController,
                          readOnly: true,
                          onTap: _pickBirthday,
                          decoration: const InputDecoration(
                            labelText: 'Birthday',
                            prefixIcon: Icon(LucideIcons.calendar),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FormSection(
              title: 'Lifestyle',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity level',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Low', 'Moderate', 'High', 'Very High']
                        .map(
                          (level) => ChoiceChip(
                            label: Text(level),
                            selected: _activityLevel == level,
                            onSelected: (_) =>
                                setState(() => _activityLevel = level),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _foodController,
                    decoration: const InputDecoration(
                      labelText: 'Food preference',
                      prefixIcon: Icon(LucideIcons.utensils),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _allergiesController,
                    decoration: const InputDecoration(
                      labelText: 'Allergies',
                      prefixIcon: Icon(LucideIcons.alertCircle),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FormSection(
              title: 'Health notes',
              child: Column(
                children: [
                  TextField(
                    controller: _healthController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Health conditions',
                      prefixIcon: Icon(LucideIcons.heart),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Additional notes',
                      prefixIcon: Icon(LucideIcons.alertCircle),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _saveDog,
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
                label: Text(
                  _saving
                      ? 'Saving profile...'
                      : (isEditing
                            ? 'Update dog profile'
                            : 'Create dog profile'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.muted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

String _capitalize(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}
