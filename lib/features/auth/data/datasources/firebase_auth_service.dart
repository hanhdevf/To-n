import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:galaxymob/core/error/exceptions.dart';
import 'package:galaxymob/features/auth/data/models/user_model.dart';

/// Firebase Authentication Service
/// Handles all Firebase Auth operations including Email/Password and Google Sign-In
class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _isGoogleSignInInitialized = false;

  FirebaseAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.instance;

  /// Get current Firebase user
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  /// Initialize Google Sign-In if not already done
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    }
  }

  /// Login with email and password
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException('Login failed: No user returned');
      }

      return _mapFirebaseUserToModel(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  /// Register with email and password
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException('Registration failed: No user returned');
      }

      // Update display name
      await user.updateDisplayName(displayName);
      await user.reload();

      return _mapFirebaseUserToModel(_firebaseAuth.currentUser ?? user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  /// Login with Google account
  Future<UserModel> loginWithGoogle() async {
    try {
      // Initialize Google Sign-In
      await _ensureGoogleSignInInitialized();

      // Check if supportsAuthenticate
      if (!_googleSignIn.supportsAuthenticate()) {
        throw const AuthException(
            'Google Sign-In is not supported on this device');
      }

      // Start sign-in flow using authenticate()
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();

      if (googleUser == null) {
        throw const AuthException('Google Sign-In was cancelled');
      }

      // Request authorization to get access token
      final authorization = await googleUser.authorizationClient
          .authorizeScopes(<String>['email', 'profile']);
      final String? accessToken = authorization.accessToken;

      // Get authenticaton details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw const AuthException('Failed to get Google access token');
      }

      // Create a new credential for Firebase
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('Google Sign-In failed: No user returned');
      }

      return _mapFirebaseUserToModel(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Google Sign-In failed: ${e.toString()}');
    }
  }

  /// Get current user as UserModel
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _mapFirebaseUserToModel(user);
  }

  /// Logout
  Future<void> logout() async {
    await _ensureGoogleSignInInitialized();
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.disconnect(),
    ]);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  /// Map Firebase User to UserModel
  UserModel _mapFirebaseUserToModel(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? user.email?.split('@').first ?? 'User',
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }

  /// Map Firebase Auth error codes to user-friendly messages
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method';
      default:
        return 'Authentication error: $code';
    }
  }
}
