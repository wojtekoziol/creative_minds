import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserStreamProvider = StreamProvider<User?>((ref) {
  final firebaseUser = ref.watch(currentFirebaseUserStreamProvider).value;

  final snapshots = ref
      .read(firebaseFirestoreProvider)
      .collection('users')
      .where('id', isEqualTo: firebaseUser?.uid)
      .snapshots();

  return snapshots.map<User?>(
    (snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return User.fromDocument(snapshot.docs.first);
    },
  );
});

final userStreamProvider = StreamProvider.family<User?, String>((ref, userID) {
  final snapshots = ref
      .read(firebaseFirestoreProvider)
      .collection('users')
      .where('id', isEqualTo: userID)
      .snapshots();

  return snapshots.map<User?>(
    (snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return User.fromDocument(snapshot.docs.first);
    },
  );
});
