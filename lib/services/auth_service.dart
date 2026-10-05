import 'package:firebase_auth/firebase_auth.dart';

// This is where we handle all the Firebase login and sign up stuff
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth;

  // We use a singleton so we can access this service from anywhere
  static AuthService instance = AuthService();

  final FirebaseAuth? _auth;

  // This getter returns the firebase auth instance
  FirebaseAuth get _firebaseAuth => _auth ?? FirebaseAuth.instance;

  // Tells us if the user's login state changed (like logged in or logged out)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Similar to authStateChanges but also gives updates for things like email verification
  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  // Get the current user that is signed in
  User? get currentUser => _firebaseAuth.currentUser;

  // Check if the user has clicked the verification link in their email
  bool get isEmailVerified {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  // Create a new user with an email and password
  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Sign in an existing user
  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Sign out the user from the app
  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  // Send an email to reset the password if they forgot it
  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return _firebaseAuth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // Send a link to the user's email to verify they own it
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No authenticated user found.',
      );
    }

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Refresh the user data to see if they just verified their email
  Future<User?> refreshUser() async {
    final user = _firebaseAuth.currentUser;

    await user?.reload();

    return _firebaseAuth.currentUser;
  }
}
