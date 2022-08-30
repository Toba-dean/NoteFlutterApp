import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// annotation that says this class or its subclass internals cannot be changed upon initialization.
@immutable
// This abstracts the current user at firebase level and checks for email verification.
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  // This returns an instance of the AuthUser class
  // made o copy of the firebase User into the AuthUser, so abstracting the firebase user and all of its other props

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
