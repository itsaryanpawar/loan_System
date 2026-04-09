import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  String _selectedRole = 'user';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── LOGIN FUNCTION ───
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      if (mounted) {
        if (_selectedRole == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    }
  }

  // ─── GOOGLE LOGIN ───
  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Login Coming Soon!'),
          backgroundColor: Colors.orange,
        ),
      );
      // TODO: Add Firebase Google Sign In
      // Navigator.pushReplacementNamed(context, '/');
    }
  }

  // ─── APPLE LOGIN ───
  void _handleAppleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apple Login Coming Soon!'),
          backgroundColor: Colors.black,
        ),
      );
      // TODO: Add Apple Sign In
      // Navigator.pushReplacementNamed(context, '/');
    }
  }

  // ─── OPEN REGISTER BOTTOM SHEET ───
  void _openRegisterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ← Full height
      backgroundColor: Colors.transparent,
      builder: (context) => const RegisterBottomSheet(),
    ).then((result) {
      // After Register → Go to Home
      if (result == true) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildLoginCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance,
              size: 55,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'QuickLoan',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Instant Loan Approval',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // LOGIN CARD
  // ─────────────────────────────────────────
  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back 👋',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Please sign in to continue',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 20),

            // Role Selector
            _buildRoleSelector(),
            const SizedBox(height: 20),

            // Email
            _buildLabel('Email Address'),
            const SizedBox(height: 8),
            _buildEmailField(),
            const SizedBox(height: 16),

            // Password
            _buildLabel('Password'),
            const SizedBox(height: 8),
            _buildPasswordField(),
            const SizedBox(height: 12),

            // Remember & Forgot
            _buildRememberAndForgot(),
            const SizedBox(height: 24),

            // Login Button
            _buildLoginButton(),
            const SizedBox(height: 20),

            // ─── OR DIVIDER ───
            _buildDivider(),
            const SizedBox(height: 20),

            // ─── SOCIAL LOGIN BUTTONS ───
            _buildSocialLoginButtons(),
            const SizedBox(height: 20),

            // ─── REGISTER LINK ───
            _buildRegisterLink(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // ROLE SELECTOR
  // ─────────────────────────────────────────
  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // User
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedRole = 'user'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedRole == 'user'
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color:
                          _selectedRole == 'user' ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'User',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedRole == 'user'
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Admin
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedRole = 'admin'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedRole == 'admin'
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 18,
                      color:
                          _selectedRole == 'admin' ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Admin',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedRole == 'admin'
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // LABEL
  // ─────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }

  // ─────────────────────────────────────────
  // EMAIL FIELD
  // ─────────────────────────────────────────
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
        prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  // ─────────────────────────────────────────
  // PASSWORD FIELD
  // ─────────────────────────────────────────
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey.shade500,
          ),
          onPressed: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your password';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );
  }

  // ─────────────────────────────────────────
  // REMEMBER ME & FORGOT PASSWORD
  // ─────────────────────────────────────────
  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (value) => setState(() => _rememberMe = value!),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Forgot Password?',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // LOGIN BUTTON
  // ─────────────────────────────────────────
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Sign In',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // DIVIDER
  // ─────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR CONTINUE WITH',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  // ─────────────────────────────────────────
  // SOCIAL LOGIN BUTTONS ← NEW
  // ─────────────────────────────────────────
  Widget _buildSocialLoginButtons() {
    return Row(
      children: [
        // ── GOOGLE BUTTON ──
        Expanded(
          child: GestureDetector(
            onTap: _handleGoogleLogin,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Official Google Icon
                  const FaIcon(
                    FontAwesomeIcons.google,
                    size: 20,
                    color: Color(0xFFDB4437), // Google Red
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Google',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // ── APPLE BUTTON ──
        Expanded(
          child: GestureDetector(
            onTap: _handleAppleLogin,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.black, // Apple Black
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Official Apple Icon
                  const FaIcon(
                    FontAwesomeIcons.apple,
                    size: 22,
                    color: Colors.white, // Apple White
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Apple',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // REGISTER LINK ← UPDATED
  // ─────────────────────────────────────────
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
        GestureDetector(
          // ✅ Opens Register Bottom Sheet
          onTap: _openRegisterSheet,
          child: Text(
            'Register Now',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  REGISTER BOTTOM SHEET WIDGET ← NEW
// ═══════════════════════════════════════════════════════════
class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({Key? key}) : super(key: key);

  @override
  State<RegisterBottomSheet> createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<RegisterBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── REGISTER FUNCTION ───
  void _handleRegister() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Created Successfully! 🎉'),
            backgroundColor: Colors.green,
          ),
        );

        // Close bottom sheet and go to home
        Navigator.pop(context, true); // ← true = success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ─── BOTTOM SHEET CONTAINER ───
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // ─── DRAG HANDLE ───
          _buildDragHandle(),

          // ─── SCROLLABLE CONTENT ───
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    _buildSheetTitle(),
                    const SizedBox(height: 24),

                    // Full Name
                    _buildLabel('Full Name'),
                    const SizedBox(height: 8),
                    _buildNameField(),
                    const SizedBox(height: 16),

                    // Email
                    _buildLabel('Email Address'),
                    const SizedBox(height: 8),
                    _buildEmailField(),
                    const SizedBox(height: 16),

                    // Phone
                    _buildLabel('Phone Number'),
                    const SizedBox(height: 8),
                    _buildPhoneField(),
                    const SizedBox(height: 16),

                    // Password
                    _buildLabel('Password'),
                    const SizedBox(height: 8),
                    _buildPasswordField(),
                    const SizedBox(height: 16),

                    // Confirm Password
                    _buildLabel('Confirm Password'),
                    const SizedBox(height: 8),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 20),

                    // Terms & Conditions
                    _buildTermsCheckbox(),
                    const SizedBox(height: 24),

                    // Register Button
                    _buildRegisterButton(),
                    const SizedBox(height: 16),

                    // Already have account
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // DRAG HANDLE
  // ─────────────────────────────────────────
  Widget _buildDragHandle() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 45,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // ─────────────────────────────────────────
  // SHEET TITLE
  // ─────────────────────────────────────────
  Widget _buildSheetTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account 🚀',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Fill in your details to get started',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        // Close Button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // LABEL
  // ─────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }

  // ─────────────────────────────────────────
  // FIELD DECORATION HELPER
  // ─────────────────────────────────────────
  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  // ─────────────────────────────────────────
  // NAME FIELD
  // ─────────────────────────────────────────
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: _fieldDecoration(
        hint: 'Enter your full name',
        icon: Icons.person_outline,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your name';
        if (value.length < 3) return 'Name must be at least 3 characters';
        return null;
      },
    );
  }

  // ─────────────────────────────────────────
  // EMAIL FIELD
  // ─────────────────────────────────────────
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: _fieldDecoration(
        hint: 'Enter your email',
        icon: Icons.email_outlined,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  // ─────────────────────────────────────────
  // PHONE FIELD
  // ─────────────────────────────────────────
  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: _fieldDecoration(
        hint: 'e.g. 03001234567',
        icon: Icons.phone_outlined,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your phone';
        if (value.length < 10) return 'Enter a valid phone number';
        return null;
      },
    );
  }

  // ─────────────────────────────────────────
  // PASSWORD FIELD
  // ─────────────────────────────────────────
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: _fieldDecoration(
        hint: 'Create a password',
        icon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
          onPressed: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a password';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );
  }

  // ─────────────────────────────────────────
  // CONFIRM PASSWORD FIELD
  // ─────────────────────────────────────────
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: _fieldDecoration(
        hint: 'Confirm your password',
        icon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
          onPressed: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Please confirm your password';
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  // ─────────────────────────────────────────
  // TERMS & CONDITIONS CHECKBOX
  // ─────────────────────────────────────────
  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _agreeToTerms,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (value) => setState(() => _agreeToTerms = value!),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // REGISTER BUTTON
  // ─────────────────────────────────────────
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Create Account',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // ALREADY HAVE ACCOUNT LINK
  // ─────────────────────────────────────────
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context), // ← Close sheet → back to login
          child: Text(
            'Sign In',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
