import 'package:creative_minds/data/controllers/auth_controller.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsStreamProvider = StreamProvider<List<Post>>((ref) {
  final snapshots =
      ref.read(firebaseFirestoreProvider).collection('posts').snapshots();

  return snapshots.map<List<Post>>(
    (snapshot) => snapshot.docs.map(Post.fromDocument).toList(),
  );
});

final userPostsStreamProvider = StreamProvider<List<Post>>((ref) {
  final user = ref.watch(authControllerProvider);

  final snapshots = ref
      .read(firebaseFirestoreProvider)
      .collection('posts')
      .where('userID', isEqualTo: user?.uid)
      .snapshots();

  return snapshots.map<List<Post>>(
    (snapshot) => snapshot.docs.map(Post.fromDocument).toList(),
  );
});
