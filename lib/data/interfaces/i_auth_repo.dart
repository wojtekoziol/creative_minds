import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepo {
  Stream<User?> get authStateChanges;
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}
