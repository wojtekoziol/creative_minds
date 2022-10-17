import 'package:creative_minds/data/interfaces/i_auth_repo.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthRepoProvider = Provider(FirebaseAuthRepo.new);

class FirebaseAuthRepo extends IAuthRepo {
  FirebaseAuthRepo(this._ref);

  final Ref _ref;

  @override
  Stream<User?> get authStateChanges =>
      _ref.read(firebaseAuthProvider).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    await _ref.read(firebaseAuthProvider).signInAnonymously();
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _ref
        .read(firebaseAuthProvider)
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOut();
  }
}
