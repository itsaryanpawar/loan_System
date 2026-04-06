import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFD63031);

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient successGradient = const LinearGradient(
    colors: [Color(0xFF00B894), Color(0xFF00A383)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppConstants {
  static const String appName = 'QuickLoan';
  static const String baseUrl = 'https://your-api-endpoint.com/api';

  static const List<String> loanTypes = [
    'Personal Loan',
    'Business Loan',
    'Home Loan',
  ];

  static const List<String> employmentTypes = [
    'Salaried',
    'Self-Employed',
    'Business Owner',
    'Freelancer',
  ];

  static const Map<String, IconData> loanIcons = {
    'Personal Loan': Icons.person,
    'Business Loan': Icons.business_center,
    'Home Loan': Icons.home,
  };
}
