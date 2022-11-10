import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

final currentFirebaseUserStreamProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);
