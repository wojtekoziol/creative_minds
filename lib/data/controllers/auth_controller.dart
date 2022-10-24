import 'dart:async';

import 'package:creative_minds/data/models/user.dart' as cm_user;
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:creative_minds/data/repositories/firebase_auth_repo.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, User?>(AuthController.new);

class AuthController extends StateNotifier<User?> {
  AuthController(this._ref) : super(null) {
    _authStateChangesSubscription?.cancel();
    final authRepo = _ref.read(firebaseAuthRepoProvider);
    _authStateChangesSubscription = authRepo.authStateChanges.listen((user) {
      state = user;
    });
  }

  final Ref _ref;
  StreamSubscription<User?>? _authStateChangesSubscription;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _ref
        .read(firebaseAuthRepoProvider)
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInAnonymously() async {
    await _ref.read(firebaseAuthRepoProvider).signInAnonymously();
    final user = _ref.read(firebaseAuthProvider).currentUser;
    state = user;
    if (user == null) return;
    await _ref.read(firestoreRepoProvider).addUser(cm_user.User(id: user.uid));
  }

  Future<void> signOut() async {
    await _ref.read(firebaseAuthRepoProvider).signOut();
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }
}
