import 'package:barkbites_app/features/auth/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Intro page shows primary auth actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: IntroPage()));

    expect(find.text('The Barksite'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsWidgets);
  });
}
