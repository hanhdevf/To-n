import 'package:galaxymob/core/error/exceptions.dart';
import 'package:galaxymob/features/auth/data/models/user_model.dart';

/// Mock remote data source for authentication
/// Simulates API calls without actual backend
class MockAuthRemoteDataSource {
  // Mock database of users
  static final Map<String, Map<String, dynamic>> _mockUsers = {
    'user@test.com': {
      'id': '1',
      'email': '1',
      'password': '1',
      'displayName': 'Test User',
      'photoUrl': null,
      'createdAt': DateTime(2024, 1, 1).toIso8601String(),
    },
    'admin@test.com': {
      'id': '2',
      'email': 'admin@test.com',
      'password': 'admin123',
      'displayName': 'Admin User',
      'photoUrl': 'https://i.pravatar.cc/150?img=1',
      'createdAt': DateTime(2024, 1, 1).toIso8601String(),
    },
  };

  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  /// Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Check if user exists
    if (!_mockUsers.containsKey(email)) {
      throw const AuthException('User not found');
    }

    final userData = _mockUsers[email]!;

    // Check password
    if (userData['password'] != password) {
      throw const AuthException('Invalid password');
    }

    // Return user data (without password)
    final Map<String, dynamic> userJson = Map.from(userData);
    userJson.remove('password');
    // Keep createdAt as String - freezed will parse it automatically

    return UserModel.fromJson(userJson);
  }

  /// Register new user
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _simulateNetworkDelay();

    // Check if user already exists
    if (_mockUsers.containsKey(email)) {
      throw const AuthException('Email already in use');
    }

    // Create new user
    final String newId = (_mockUsers.length + 1).toString();
    final now = DateTime.now();

    final newUser = {
      'id': newId,
      'email': email,
      'password': password,
      'displayName': displayName,
      'photoUrl': null,
      'createdAt': now.toIso8601String(),
    };

    // Add to mock database
    _mockUsers[email] = newUser;

    // Return user data (without password)
    return UserModel(
      id: newId,
      email: email,
      displayName: displayName,
      photoUrl: null,
      createdAt: now,
    );
  }
}
