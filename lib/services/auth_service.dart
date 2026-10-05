import 'package:firebase_auth/firebase_auth.dart';

// This is where we handle all the Firebase login and sign up stuff
class AuthService {
  // ignore: prefer_initializing_formals
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

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Refresh current user
  Future<User?> refreshUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      user = _firebaseAuth.currentUser;
    }
    return user;
  }

  // Login with email and password
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Register with email and password
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
