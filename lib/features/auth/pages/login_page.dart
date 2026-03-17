import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../theme.dart';
import '../widgets/auth_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Please fill in all fields', isError: true);
      return;
    }

    setState(() => _loading = true);
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email, password);
    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      _showSnack('Welcome back');
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      _showSnack(authProvider.error ?? 'Login failed', isError: true);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.destructive : AppTheme.foreground,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      hero: const AuthHero(
        badge: 'Sign in',
        headline: 'Welcome back to your dog dashboard',
        description:
            'Pick up where you left off with schedules, profiles, and nutrition plans already organized for your dogs.',
        metrics: ['Fast access', 'Profile switching', 'Synced data'],
      ),
      title: 'Sign in',
      subtitle: 'Minimal setup, instant access, and your dog routines ready.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthField(
            label: 'Email',
            icon: LucideIcons.mail,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'you@example.com'),
            ),
          ),
          const SizedBox(height: 16),
          AuthField(
            label: 'Password',
            icon: LucideIcons.lock,
            child: TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                  icon: Icon(
                    _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _handleLogin,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.logIn),
              label: Text(
                _loading ? 'Signing in...' : 'Sign in',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      topAction: TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
        child: const Text('Create Account'),
      ),
      bottomText: const Text(
        "Don't have an account? ",
        style: TextStyle(color: AppTheme.mutedText),
      ),
      bottomAction: TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
        child: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
