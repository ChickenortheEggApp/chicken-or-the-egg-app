import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Current user stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  static User? get currentUser => _auth.currentUser;

  // Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
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

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Optional: Update user profile with Google info
      if (userCredential.user != null) {
        await _updateUserProfile(userCredential.user!, googleUser);
      }
      
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
      rethrow;
    }
  }

  // Sign in anonymously (for guests)
  static Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in anonymously: $e');
      }
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();
      // Sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      rethrow;
    }
  }

  // Update user profile with Google information
  static Future<void> _updateUserProfile(User user, GoogleSignInAccount googleUser) async {
    try {
      await user.updateDisplayName(googleUser.displayName);
      await user.updatePhotoURL(googleUser.photoUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
    }
  }

  // Get user display name
  static String getUserDisplayName() {
    final user = currentUser;
    if (user != null) {
      return user.displayName ?? user.email ?? 'Chicken Farmer';
    }
    return 'Guest';
  }

  // Get user email
  static String? getUserEmail() {
    return currentUser?.email;
  }

  // Check if user is signed in with Google
  static bool isSignedInWithGoogle() {
    final user = currentUser;
    if (user != null) {
      return user.providerData.any((info) => info.providerId == 'google.com');
    }
    return false;
  }

  // Check if user is anonymous
  static bool isAnonymous() {
    return currentUser?.isAnonymous ?? true;
  }

  // Convert anonymous account to Google account
  static Future<UserCredential?> linkWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link the anonymous account with Google
      return await currentUser?.linkWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print('Error linking with Google: $e');
      }
      rethrow;
    }
  }
}
