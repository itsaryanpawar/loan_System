// lib/services/auth_service.dart

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  // ─── SIGN UP ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String city,
  }) async {
    try {
      // username = email (as per Back4App convention)
      final user = ParseUser.createUser(email, password, email);

      // Set extra fields
      user.set<String>('fullName', fullName);
      user.set<String>('phone', phone);
      user.set<String>('city', city);

      final response = await user.signUp();

      if (response.success) {
        return {'success': true, 'message': 'Account created successfully'};
      } else {
        return {
          'success': false,
          'message': response.error?.message ?? 'Sign up failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── LOGIN ────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final user = ParseUser(email, password, email);
      final response = await user.login();

      if (response.success) {
        final loggedUser = response.result as ParseUser;
        
        // Store role if needed
        loggedUser.set<String>('role', role);
        await loggedUser.save();
        
        return {
          'success': true,
          'userName': loggedUser.get<String>('fullName') ?? email,
          'role': role,
        };
      } else {
        return {
          'success': false,
          'message': response.error?.message ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── IS LOGGED IN ─────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) return false;

    final sessionToken = user.sessionToken;
    if (sessionToken == null) return false;

    final response = await ParseUser.getCurrentUserFromServer(sessionToken);
    return response?.success == true;
  }

  // ─── LOGOUT ───────────────────────────────────────────────
  static Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }
}