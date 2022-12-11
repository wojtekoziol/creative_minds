import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentsStreamProvider =
    StreamProvider.family<List<Comment>, String>((ref, postID) {
  final snapshots = ref
      .read(firebaseFirestoreProvider)
      .collection('comments')
      .where('postID', isEqualTo: postID)
      .snapshots();

  return snapshots.map<List<Comment>>(
    (snapshot) => snapshot.docs.map(Comment.fromDocument).toList(),
  );
});
