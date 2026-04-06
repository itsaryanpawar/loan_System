import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loan_application.dart';

class ApiService {
  // Simulating API calls with local storage
  static const String _storageKey = 'loan_applications';

  Future<bool> submitLoanApplication(LoanApplication application) async {
    try {
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate network delay

      final prefs = await SharedPreferences.getInstance();
      List<String> applications = prefs.getStringList(_storageKey) ?? [];

      application.createdAt = DateTime.now();
      applications.add(jsonEncode(application.toJson()));

      await prefs.setStringList(_storageKey, applications);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error submitting application: $e');
      }
      return false;
    }
  }

  Future<List<LoanApplication>> getAllApplications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> applications = prefs.getStringList(_storageKey) ?? [];

      return applications
          .map((app) => LoanApplication.fromJson(jsonDecode(app)))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching applications: $e');
      }
      return [];
    }
  }

  bool checkEligibility(LoanApplication application) {
    // Simple eligibility logic
    final income = int.tryParse(application.monthlyIncome ?? '0') ?? 0;

    if (application.loanType == 'Personal Loan') {
      return income >= 25000;
    } else if (application.loanType == 'Business Loan') {
      return income >= 40000;
    } else if (application.loanType == 'Home Loan') {
      return income >= 50000;
    }

    return false;
  }

  Future<void> clearAllApplications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
