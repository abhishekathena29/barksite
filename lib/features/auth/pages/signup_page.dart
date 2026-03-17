import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../theme.dart';
import '../widgets/auth_shell.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill in all fields', isError: true);
      return;
    }
    if (password != confirm) {
      _showSnack('Passwords do not match', isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters', isError: true);
      return;
    }

    setState(() => _loading = true);
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(name, email, password);
    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      _showSnack('Account created');
      Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    } else {
      _showSnack(authProvider.error ?? 'Signup failed', isError: true);
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
        badge: 'Create account',
        headline: 'Set up a calmer routine for every dog',
        description:
            'Start with your account, then add dog profiles, switch between them, and keep every schedule organized from day one.',
        metrics: ['Quick setup', 'Multiple dogs', 'Personal planning'],
      ),
      title: 'Create account',
      subtitle: 'A cleaner start for dog profiles, schedules, and daily care.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthField(
            label: 'Full name',
            icon: LucideIcons.user,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'John Doe'),
            ),
          ),
          const SizedBox(height: 16),
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
                hintText: 'At least 6 characters',
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
          const SizedBox(height: 16),
          AuthField(
            label: 'Confirm password',
            icon: LucideIcons.lock,
            child: TextField(
              controller: _confirmController,
              obscureText: !_showPassword,
              decoration: const InputDecoration(hintText: 'Re-enter password'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _handleSignup,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.userPlus),
              label: Text(
                _loading ? 'Creating account...' : 'Create account',
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
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        child: const Text('Sign In'),
      ),
      bottomText: const Text(
        'Already have an account? ',
        style: TextStyle(color: AppTheme.mutedText),
      ),
      bottomAction: TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        child: const Text(
          'Log in',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
