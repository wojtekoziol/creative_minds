import 'dart:async';

import 'package:creative_minds/data/models/user.dart' as cm_user;
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

  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authRepo = _ref.read(firebaseAuthRepoProvider);
      await authRepo.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firestoreRepo = _ref.read(firestoreRepoProvider);
      await firestoreRepo.addUser(cm_user.User(
        id: state?.uid ?? '',
        email: state?.email ?? '',
      ));
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _ref
          .read(firebaseAuthRepoProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseException {
      return false;
    }
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
