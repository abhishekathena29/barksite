import 'package:flutter/material.dart';

import '../theme.dart';
import 'bottom_nav.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.child,
    this.title,
    this.showBottomNav = true,
  });

  final Widget child;
  final String? title;
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';
    return Scaffold(
      extendBody: true,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(
                title!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? BottomNav(currentRoute: routeName)
          : null,
    );
  }
}
