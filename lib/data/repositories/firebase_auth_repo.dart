import 'package:creative_minds/data/interfaces/i_auth_repo.dart';
import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthRepoProvider = Provider(FirebaseAuthRepo.new);

class FirebaseAuthRepo extends IAuthRepo {
  FirebaseAuthRepo(this._ref);

  final Ref _ref;

  @override
  Stream<auth.User?> get authStateChanges =>
      _ref.read(firebaseAuthProvider).authStateChanges();

  @override
  Future<User?> getCurrentUser() async {
    throw UnsupportedError('Unimplemented method');
    final user = _ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return null;
    return _ref.read(firestoreRepoProvider).getUser(user.uid);
  }

  @override
  Future<void> signInAnonymously() async {
    final credential =
        await _ref.read(firebaseAuthProvider).signInAnonymously();
    await _ref
        .read(firestoreRepoProvider)
        .addUser(User.fromCredential(credential));
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _ref
        .read(firebaseAuthProvider)
        .signInWithEmailAndPassword(email: email, password: password);
    await _ref
        .read(firestoreRepoProvider)
        .addUser(User.fromCredential(credential));
  }

  @override
  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOut();
  }
}
