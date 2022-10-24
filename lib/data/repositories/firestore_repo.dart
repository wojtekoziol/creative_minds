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
    await collection.doc(user.id).set(user.toJson());
  }

  @override
  Future<User?> getUser(String? id) async {
    if (id == null) return null;
    final snapshot = await _ref
        .read(firebaseFirestoreProvider)
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return User.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<void> updateUser(User user) async {
    final collection = _ref.read(firebaseFirestoreProvider).collection('users');
    await collection.doc(user.id).update(user.toJson());
  }

  @override
  Future<void> addPost(Post post) async {
    final collection = _ref.read(firebaseFirestoreProvider).collection('posts');
    await collection.add(post.toJson());
  }

  @override
  Future<List<Post>?> getAllPosts() async {
    final snapshot =
        await _ref.read(firebaseFirestoreProvider).collection('posts').get();
    final posts =
        snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    return posts;
  }

  @override
  Future<List<Post>?> getUserPosts(String userID) async {
    final snapshot = await _ref
        .read(firebaseFirestoreProvider)
        .collection('posts')
        .where('userID', isEqualTo: userID)
        .get();
    final posts =
        snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    return posts;
  }

  @override
  Future<void> addComment(Comment comment) async {
    final collection =
        _ref.read(firebaseFirestoreProvider).collection('comments');
    await collection.add(comment.toJson());
  }

  @override
  Future<List<Comment>?> getComments(String postID) async {
    final snapshot = await _ref
        .read(firebaseFirestoreProvider)
        .collection('comments')
        .where('postID', isEqualTo: postID)
        .get();
    final comments =
        snapshot.docs.map((doc) => Comment.fromJson(doc.data())).toList();
    return comments;
  }
}
