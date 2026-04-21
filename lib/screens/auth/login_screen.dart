import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:loan_lead_app/screens/dashboard/home_screen.dart';
import 'package:loan_lead_app/screens/auth/signupscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isUserTab = true;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── LOGIN FUNCTION ───────────────────────────────────────
  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = ParseUser(
        _emailController.text.trim(),
        _passwordController.text,
        _emailController.text.trim(),
      );

      final response = await user.login();

      if (!mounted) return;

      if (response.success) {
        final ParseUser? loggedInUser =
            await ParseUser.currentUser() as ParseUser?;

        if (loggedInUser != null) {
          // ✅ Generate Full Name if not exists
          final existingName = loggedInUser.get<String>('fullName') ?? '';

          if (existingName.isEmpty) {
            final rawUsername = loggedInUser.username ?? '';
            String derivedName = '';

            if (rawUsername.contains('@')) {
              final localPart = rawUsername.split('@').first;

              derivedName = localPart
                  .split(RegExp(r'[._]'))
                  .map((w) => w.isNotEmpty
                      ? w[0].toUpperCase() + w.substring(1).toLowerCase()
                      : '')
                  .join(' ');
            } else {
              derivedName = rawUsername;
            }

            loggedInUser.set<String>('fullName', derivedName);
            await loggedInUser.save();
          }

          // ✅ Navigate to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(
                userName: loggedInUser.get<String>('fullName') ??
                    loggedInUser.username ??
                    'User',
              ),
            ),
          );
        }
      } else {
        setState(
            () => _errorMessage = response.error?.message ?? 'Login failed');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong');
    }

    setState(() => _isLoading = false);
  }

  // ─── NAVIGATE TO SIGNUP ──────────────────────────────────
  void _goToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  // ─── UI BUILD ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── HEADER ──
          Container(
            width: double.infinity,
            height: 220,
            color: const Color(0xFF6C63FF),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance, size: 60, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'QuickLoan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Instant Loan Approval',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // ── BODY ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back 👋',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Please sign in to continue',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // ── TABS ──
                  Row(
                    children: [
                      _tabButton(
                        'User',
                        _isUserTab,
                        () => setState(() => _isUserTab = true),
                      ),
                      const SizedBox(width: 8),
                      _tabButton(
                        'Admin',
                        !_isUserTab,
                        () => setState(() => _isUserTab = false),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── EMAIL ──
                  const Text('Email Address',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: _inputDecoration(
                        'Enter your email', Icons.email_outlined),
                  ),

                  const SizedBox(height: 16),

                  // ── PASSWORD ──
                  const Text('Password',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration(
                            'Enter your password', Icons.lock_outline)
                        .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── REMEMBER + FORGOT ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF6C63FF),
                            onChanged: (value) =>
                                setState(() => _rememberMe = value!),
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ],
                  ),

                  // ── ERROR ──
                  if (_errorMessage.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── LOGIN BUTTON ──
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Sign In'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── SIGNUP ──
                  Center(
                    child: TextButton(
                      onPressed: _goToSignUp,
                      child: const Text("Create New Account"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TAB BUTTON ──
  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF6C63FF) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  // ─── INPUT STYLE ──
  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
