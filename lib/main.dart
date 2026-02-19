import 'package:barkbites_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/intro_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/dog_profile_page.dart';
import 'screens/diet_plans_page.dart';
import 'screens/food_brands_page.dart';
import 'screens/brand_stores_page.dart';
import 'screens/map_page.dart';
import 'screens/calendar_page.dart';
import 'screens/not_found_page.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BarkBitesApp());
}

class BarkBitesApp extends StatelessWidget {
  const BarkBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Barksite',
      theme: AppTheme.lightTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const DogProfilePage(),
        '/diet-plans': (context) => const DietPlansPage(),
        '/food-brands': (context) => const FoodBrandsPage(),
        '/brand-stores': (context) => const BrandStoresPage(),
        '/map': (context) => const MapPage(),
        '/calendar': (context) => const CalendarPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
      },
    );
  }
}
