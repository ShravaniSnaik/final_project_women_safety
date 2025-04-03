import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  // Constructor (allows dependency injection for testing)
  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// ✅ Sign in method
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Sign-in error: $e");
      return null;
    }
  }

  /// ✅ Sign up method
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Sign-up error: $e");
      return null;
    }
  }

  /// ✅ Sign out method
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// ✅ Get currently logged-in user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}