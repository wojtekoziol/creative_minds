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
  Future<List<Post>?> getAllPosts() async {
    final snapshot =
        await _ref.read(firebaseFirestoreProvider).collection('posts').get();
    final posts = snapshot.docs.map(Post.fromDocument).toList();
    return posts;
  }

  @override
  Future<List<Comment>?> getComments(String postID) async {
    final snapshot = await _ref
        .read(firebaseFirestoreProvider)
        .collection('comments')
        .where('postID', isEqualTo: postID)
        .get();
    final comments = snapshot.docs.map(Comment.fromDocument).toList();
    return comments;
  }

  @override
  Future<User?> getUser(String id) async {
    final docs = await _ref
        .read(firebaseFirestoreProvider)
        .collection('users')
        .where('id', isEqualTo: id)
        .get()
        .then((value) => value.docs);
    if (docs.isEmpty) return null;
    return docs.map(User.fromDocument).first;
  }

  @override
  Future<List<Post>?> getUserPosts(String authorID) async {
    final snapshot = await _ref
        .read(firebaseFirestoreProvider)
        .collection('posts')
        .where('authorID', isEqualTo: authorID)
        .get();
    final posts = snapshot.docs.map(Post.fromDocument).toList();
    return posts;
  }

  @override
  Future<void> addComment(Comment comment) async {
    final collection =
        _ref.read(firebaseFirestoreProvider).collection('comments');
    await collection.add(comment.toDocument());
  }

  @override
  Future<void> addPost(Post post) async {
    final collection = _ref.read(firebaseFirestoreProvider).collection('posts');
    await collection.add(post.toDocument());
  }

  @override
  Future<void> addUser(User user) async {
    final doesExist = await _ref
        .read(firebaseFirestoreProvider)
        .collection('users')
        .where('id', isEqualTo: user.id)
        .get()
        .then((value) => value.docs.isNotEmpty);
    if (doesExist) return;
    await _ref
        .read(firebaseFirestoreProvider)
        .collection('users')
        .add(user.toDocument());
  }
}
