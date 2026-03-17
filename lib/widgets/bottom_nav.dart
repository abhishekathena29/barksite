import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.currentRoute});

  final String currentRoute;

  static const _items = [
    _NavItem(label: 'Home', route: '/home', icon: LucideIcons.home),
    _NavItem(label: 'Map', route: '/map', icon: LucideIcons.map),
    _NavItem(label: 'Diet', route: '/diet-plans', icon: LucideIcons.utensils),
    _NavItem(label: 'Calendar', route: '/calendar', icon: LucideIcons.calendar),
    _NavItem(label: 'Profile', route: '/account', icon: LucideIcons.user),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: Container(
        height: 88,
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottomInset > 0 ? 8 : 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: _items.map((item) {
            final isActive = currentRoute == item.route;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (!isActive) {
                    Navigator.pushReplacementNamed(context, item.route);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: isActive ? AppTheme.primary : AppTheme.mutedText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isActive
                              ? AppTheme.primary
                              : AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final IconData icon;
}
