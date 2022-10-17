import 'package:creative_minds/data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class IAuthRepo {
  Stream<auth.User?> get authStateChanges;
  Future<User?> getCurrentUser();
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInAnonymously();
  Future<void> signOut();
}
