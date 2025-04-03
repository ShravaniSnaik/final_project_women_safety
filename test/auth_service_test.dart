import 'package:flutter_application_2/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/mockito.dart';

// Create a Mock Class for FirebaseAuth to handle failures
class MockFirebaseAuthWithFailure extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // Always throw an authentication error
    return Future.error(FirebaseAuthException(code: 'user-not-found'));
  }
}

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    // Create a mock user
    mockUser = MockUser(
      uid: "12345",
      email: "test@example.com",
      displayName: "Test User",
    );

    // Initialize MockFirebaseAuth
    mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
  });

  test('✅ Sign in with valid credentials', () async {
    final user = await authService.signIn("test@example.com", "password123");

    expect(user, isNotNull);
    expect(user?.email, "test@example.com");
  });

  test('❌ Sign in fails with incorrect credentials', () async {
    // Use MockFirebaseAuthWithFailure instead
    final mockAuthFail = MockFirebaseAuthWithFailure();
    final authServiceFail = AuthService(firebaseAuth: mockAuthFail);

    // Attempt to sign in with incorrect credentials
    final user = await authServiceFail.signIn(
      "wrong@example.com",
      "wrongpassword",
    );

    // Expect null since authentication should fail
    expect(user, isNull);
  });

  test('✅ Sign out user', () async {
    await authService.signOut();

    // Ensure currentUser is null after signing out
    expect(mockFirebaseAuth.currentUser, isNull);
  });
}