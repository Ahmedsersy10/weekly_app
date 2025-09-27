import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupabaseAuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  // Get Supabase client
  static SupabaseClient get _supabase => Supabase.instance.client;

  /// Check if user is currently logged in
  static Future<bool> isLoggedIn() async {
    // Check both Supabase session and SharedPreferences
    final session = _supabase.auth.currentSession;
    final prefs = await SharedPreferences.getInstance();
    final localIsLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    // If we have a valid session, ensure local storage is updated
    if (session != null && session.user != null) {
      if (!localIsLoggedIn) {
        await _saveUserDataLocally(session.user);
      }
      return true;
    }
    
    // If no session but local storage says logged in, clear local storage
    if (session == null && localIsLoggedIn) {
      await _clearUserDataLocally();
      return false;
    }
    
    return localIsLoggedIn;
  }

  /// Get current user
  static User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    final user = getCurrentUser();
    if (user != null) {
      return user.email;
    }
    
    // Fallback to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    final user = getCurrentUser();
    if (user != null) {
      return user.id;
    }
    
    // Fallback to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Get user display name
  static Future<String?> getUserName() async {
    final user = getCurrentUser();
    if (user != null) {
      // Try to get name from user metadata or email
      final metadata = user.userMetadata;
      if (metadata != null && metadata['full_name'] != null) {
        return metadata['full_name'] as String;
      }
      if (metadata != null && metadata['name'] != null) {
        return metadata['name'] as String;
      }
      // Fallback to email username
      if (user.email != null) {
        return user.email!.split('@').first;
      }
    }
    return null;
  }

  /// Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      if (response.user != null) {
        await _saveUserDataLocally(response.user!);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _saveUserDataLocally(response.user!);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _clearUserDataLocally();
    } catch (e) {
      // Even if Supabase signOut fails, clear local data
      await _clearUserDataLocally();
      rethrow;
    }
  }

  /// Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Save user data to SharedPreferences
  static Future<void> _saveUserDataLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, user.id);
    if (user.email != null) {
      await prefs.setString(_userEmailKey, user.email!);
    }
  }

  /// Clear user data from SharedPreferences
  static Future<void> _clearUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
  }

  /// Listen to auth state changes
  static Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  /// Initialize auth state on app start
  static Future<void> initializeAuthState() async {
    final session = _supabase.auth.currentSession;
    if (session != null && session.user != null) {
      await _saveUserDataLocally(session.user);
    } else {
      await _clearUserDataLocally();
    }
  }

  /// Get error message from AuthException
  static String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid email or password. Please try again.';
        case 'Email not confirmed':
          return 'Please check your email and click the confirmation link.';
        case 'User already registered':
          return 'An account with this email already exists.';
        case 'Password should be at least 6 characters':
          return 'Password must be at least 6 characters long.';
        case 'Unable to validate email address: invalid format':
          return 'Please enter a valid email address.';
        default:
          return error.message;
      }
    }
    return error.toString();
  }
}
