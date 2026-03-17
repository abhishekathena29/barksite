import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme.dart';
import '../widgets/auth_shell.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      hero: const AuthHero(
        badge: 'Minimal onboarding',
        headline: 'Care for every dog in one calm space',
        description:
            'Create dog profiles, switch between them instantly, and keep feeding, planning, and discovery tied to the right companion.',
        metrics: ['Dog-first profiles', 'Smart schedules', 'Cleaner routines'],
      ),
      title: 'Everything starts with one profile',
      subtitle:
          'Add your dog once and the rest of the app becomes focused, organized, and personal.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _IntroFeature(
            icon: LucideIcons.dog,
            title: 'Separate profiles for each dog',
            description:
                'Switch dogs from the top of home and keep every routine scoped correctly.',
          ),
          const SizedBox(height: 12),
          const _IntroFeature(
            icon: LucideIcons.calendar,
            title: 'Interactive weekly planning',
            description:
                'Track meals, walks, grooming, and medicine in one schedule flow.',
          ),
          const SizedBox(height: 12),
          const _IntroFeature(
            icon: LucideIcons.mapPin,
            title: 'Useful nearby places',
            description:
                'Browse stores, parks, and vets without leaving the app experience.',
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              icon: const Icon(LucideIcons.arrowRight),
              label: const Text(
                'Create account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              icon: const Icon(LucideIcons.logIn),
              label: const Text(
                'I already have an account',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      topAction: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/login'),
        child: const Text('Sign In'),
      ),
      bottomText: const Text(
        'Secure auth. Clean setup.',
        style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
      ),
    );
  }
}

class _IntroFeature extends StatelessWidget {
  const _IntroFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
