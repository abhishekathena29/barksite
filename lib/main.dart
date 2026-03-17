import 'package:barkbites_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/pages/intro_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/signup_page.dart';
import 'features/home/pages/home_page.dart';
import 'features/profile/pages/dog_profile_page.dart';
import 'features/diet/pages/diet_plans_page.dart';
import 'features/food/pages/food_brands_page.dart';
import 'features/food/pages/brand_stores_page.dart';
import 'features/map/pages/map_page.dart';
import 'features/calendar/pages/calendar_page.dart';
import 'features/misc/pages/not_found_page.dart';
import 'providers/auth_provider.dart';
import 'providers/dog_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DogProvider(context.read<AuthProvider>())),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
