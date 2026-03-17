import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      _Feature(
        icon: LucideIcons.dog,
        title: 'Dog Profiles',
        description: 'Create personalized profiles for your furry friends',
        color: const Color(0xFFF97316),
      ),
      _Feature(
        icon: LucideIcons.utensils,
        title: 'Diet Plans',
        description: 'Tailored nutrition based on breed, age and health',
        color: const Color(0xFF22C55E),
      ),
      _Feature(
        icon: LucideIcons.mapPin,
        title: 'Store Locator',
        description: 'Find pet stores and dog parks near you',
        color: const Color(0xFF3B82F6),
      ),
      _Feature(
        icon: LucideIcons.calendar,
        title: 'Meal Scheduler',
        description: 'Track feeding times and set reminders',
        color: const Color(0xFF8B5CF6),
      ),
    ];

    final highlights = [
      _Highlight(icon: LucideIcons.heart, label: 'Personalized Care'),
      _Highlight(icon: LucideIcons.shieldCheck, label: 'Health-Focused'),
      _Highlight(icon: LucideIcons.star, label: 'Premium Brands'),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCE6D2), AppTheme.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      icon: const Icon(LucideIcons.logIn, size: 16, color: AppTheme.mutedText),
                      label: const Text('Login', style: TextStyle(color: AppTheme.mutedText)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      icon: const Icon(LucideIcons.userPlus, size: 16),
                      label: const Text('Sign Up'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.foreground,
                        side: const BorderSide(color: AppTheme.border),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primary, AppTheme.accent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            )
                          ],
                        ),
                        child: const Icon(LucideIcons.dog, color: Colors.white, size: 44),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The Barksite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.foreground,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your Complete Dog Nutrition Companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Discover personalized nutrition plans and premium food recommendations for your best friend.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppTheme.mutedText, height: 1.4),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: highlights
                      .map((h) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppTheme.border),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(h.icon, size: 14, color: AppTheme.primary),
                                const SizedBox(width: 6),
                                Text(h.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.05,
                  children: features
                      .map(
                        (f) => Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.border),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: f.color,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
                                  ],
                                ),
                                child: Icon(f.icon, color: Colors.white, size: 24),
                              ),
                              const SizedBox(height: 10),
                              Text(f.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(
                                f.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11, color: AppTheme.mutedText, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    icon: const Icon(LucideIcons.arrowRight, size: 18),
                    label: const Text('Get Started', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 6,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(fontSize: 12, color: AppTheme.mutedText)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text('Sign In', style: TextStyle(color: AppTheme.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(LucideIcons.shieldCheck, size: 14, color: AppTheme.mutedText),
                    SizedBox(width: 6),
                    Text('Free to use. Secure and private.', style: TextStyle(fontSize: 12, color: AppTheme.mutedText)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Feature {
  const _Feature({required this.icon, required this.title, required this.description, required this.color});
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class _Highlight {
  const _Highlight({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
