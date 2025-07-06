import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw AuthException('Failed to sign in with Google: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }

  /// Sign in anonymously (for users who don't want to use Google)
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _firebaseAuth.signInAnonymously();
    } catch (e) {
      throw AuthException('Failed to sign in anonymously: ${e.toString()}');
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw AuthException('Failed to delete account: ${e.toString()}');
    }
  }
}

class AuthException implements Exception {
  final String message;
  
  const AuthException(this.message);
  
  @override
  String toString() => 'AuthException: $message';
}