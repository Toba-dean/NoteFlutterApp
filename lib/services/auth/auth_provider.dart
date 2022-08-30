import 'package:mynotes/services/auth/auth_user.dart';

// every provider should conform to this interface, i.e all provider should conform to this format.
abstract class AuthProvider {
  // get the currently authenticated user
  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> initialize();
}
