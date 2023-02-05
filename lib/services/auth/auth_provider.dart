import 'package:learningdart/services/auth/auth_user.dart';

abstract class AuthProvider{
  AuthUser? get currentUser;

  Future<void> initialize() async {}

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser ({
    required String email,
    required String password,
  });

  Future<void> logOut ();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}