import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:galaxymob/features/auth/data/models/user_model.dart';

/// Local data source for authentication
/// Handles token storage and user caching
class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _keyAuthToken = 'auth_token';
  static const String _keyCurrentUser = 'current_user';

  AuthLocalDataSource(this.sharedPreferences);

  /// Save auth token
  Future<void> saveAuthToken(String token) async {
    await sharedPreferences.setString(_keyAuthToken, token);
  }

  /// Get auth token
  String? getAuthToken() {
    return sharedPreferences.getString(_keyAuthToken);
  }

  /// Save current user
  Future<void> saveCurrentUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(_keyCurrentUser, userJson);
  }

  /// Get current user
  UserModel? getCurrentUser() {
    final userJson = sharedPreferences.getString(_keyCurrentUser);
    if (userJson == null) return null;

    final Map<String, dynamic> userMap = json.decode(userJson);
    // Convert createdAt string back to DateTime if it exists
    if (userMap['createdAt'] != null) {
      userMap['createdAt'] = DateTime.parse(userMap['createdAt'] as String);
    }
    return UserModel.fromJson(userMap);
  }

  /// Clear all auth data
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(_keyAuthToken);
    await sharedPreferences.remove(_keyCurrentUser);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return getAuthToken() != null;
  }
}
