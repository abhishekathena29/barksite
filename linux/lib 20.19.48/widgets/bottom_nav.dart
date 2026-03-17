import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.currentRoute});

  final String currentRoute;

  static const _items = [
    _NavItem(label: 'Home', route: '/home', icon: LucideIcons.home),
    _NavItem(label: 'Map', route: '/map', icon: LucideIcons.map),
    _NavItem(label: 'Diet Plan', route: '/diet-plans', icon: LucideIcons.utensils),
    _NavItem(label: 'Calendar', route: '/calendar', icon: LucideIcons.calendar),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: _items.map((item) {
          final isActive = currentRoute == item.route;
          return Expanded(
            child: InkWell(
              onTap: () {
                if (!isActive) {
                  Navigator.pushReplacementNamed(context, item.route);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? AppTheme.primary : AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.route, required this.icon});
  final String label;
  final String route;
  final IconData icon;
}
