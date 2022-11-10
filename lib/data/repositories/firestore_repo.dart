import 'package:creative_minds/data/interfaces/i_db_repo.dart';
import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreRepoProvider = Provider<FirestoreRepo>(FirestoreRepo.new);

class FirestoreRepo extends IDBRepo {
  FirestoreRepo(this._ref);

  final Ref _ref;

  @override
  Future<void> addUser(User user) async {
    final collection = _ref.read(firebaseFirestoreProvider).collection('users');
    await collection.doc(user.id).set(user.toDocument());
  }

  // TODO: Remove
  @override
  Future<User?> getUser(String? id) async {
    if (id == null) return null;
    final snapshot = await _ref
        .read(firebaseFirestoreProvider)
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return User.fromDocument(snapshot.docs.first);
  }

  @override
  Future<void> updateUser(User user) async {
    final collection = _ref.read(firebaseFirestoreProvider).collection('users');
    await collection.doc(user.id).update(user.toDocument());
  }

  @override
  Future<void> addPost(Post post) async {
    final collection = _ref.read(firebaseFirestoreProvider).collection('posts');
    await collection.add(post.toDocument());
  }

  @override
  Future<void> updatePost(Post post) async {
    final collection = _ref.read(firebaseFirestoreProvider).collection('posts');
    await collection.doc(post.id).update(post.toDocument());
  }

  @override
  Future<List<Post>?> getAllPosts() async {
    final snapshot =
        await _ref.read(firebaseFirestoreProvider).collection('posts').get();
    final posts = snapshot.docs.map(Post.fromDocument).toList();
    return posts;
  }

  @override
  Future<void> addComment(Comment comment) async {
    final collection =
        _ref.read(firebaseFirestoreProvider).collection('comments');
    await collection.add(comment.toDocument());
  }
}
