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

  Route<dynamic> _buildRoute({
    required RouteSettings settings,
    required Widget child,
  }) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DogProvider>(
          create: (context) => DogProvider(context.read<AuthProvider>()),
          update: (context, authProvider, previous) =>
              previous ?? DogProvider(authProvider),
        ),
      ],
      child: MaterialApp(
        title: 'The Barksite',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return _buildRoute(
                settings: settings,
                child: const _AppEntryPage(),
              );
            case '/login':
              return _buildRoute(
                settings: settings,
                child: const _PublicOnlyPage(child: LoginPage()),
              );
            case '/signup':
              return _buildRoute(
                settings: settings,
                child: const _PublicOnlyPage(child: SignupPage()),
              );
            case '/home':
              return _buildRoute(
                settings: settings,
                child: const _ProtectedPage(child: HomePage()),
              );
            case '/profile':
              return _buildRoute(
                settings: settings,
                child: const _ProtectedPage(child: DogProfilePage()),
              );
            case '/diet-plans':
              return _buildRoute(
                settings: settings,
                child: const _ProtectedPage(child: DietPlansPage()),
              );
            case '/food-brands':
              return _buildRoute(
                settings: settings,
                child: const _ProtectedPage(child: FoodBrandsPage()),
              );
            case '/brand-stores':
              return _buildRoute(
                settings: settings,
                child: const _ProtectedPage(child: BrandStoresPage()),
              );
            case '/map':
              return _buildRoute(
                settings: settings,
                child: const _ProtectedPage(child: MapPage()),
              );
            case '/calendar':
              return _buildRoute(
                settings: settings,
                child: const _ProtectedPage(child: CalendarPage()),
              );
          }
          return null;
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (_) => const NotFoundPage());
        },
      ),
    );
  }
}

class _AppEntryPage extends StatelessWidget {
  const _AppEntryPage();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.loading) {
      return const _AppLoadingPage();
    }

    if (authProvider.currentUser != null) {
      return const HomePage();
    }

    return const IntroPage();
  }
}

class _PublicOnlyPage extends StatelessWidget {
  const _PublicOnlyPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.loading) {
      return const _AppLoadingPage();
    }

    if (authProvider.currentUser != null) {
      return const HomePage();
    }

    return child;
  }
}

class _ProtectedPage extends StatelessWidget {
  const _ProtectedPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.loading) {
      return const _AppLoadingPage();
    }

    if (authProvider.currentUser == null) {
      return const IntroPage();
    }

    return child;
  }
}

class _AppLoadingPage extends StatelessWidget {
  const _AppLoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
