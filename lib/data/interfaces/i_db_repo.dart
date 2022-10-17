import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/models/user.dart';

abstract class IDBRepo {
  Future<User?> getUser(String id);
  Future<List<Post>?> getAllPosts();
  Future<List<Post>?> getUserPosts(String userID);
  Future<List<Comment>?> getComments(String postID);
  Future<void> addUser(User user);
  Future<void> addPost(Post post);
  Future<void> addComment({required String postID, required Comment comment});
}
