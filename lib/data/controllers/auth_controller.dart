import 'dart:async';

import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/repositories/firebase_auth_repo.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider(AuthController.new);

class AuthController extends StateNotifier<User?> {
  AuthController(this._ref) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription =
        _ref.read(firebaseAuthRepoProvider).authStateChanges.listen((user) {
      if (user == null) return;
      _ref
          .read(firestoreRepoProvider)
          .getUser(user.uid)
          .then((value) => state = value);
    });
  }

  final Ref _ref;
  StreamSubscription<auth.User?>? _authStateChangesSubscription;

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
