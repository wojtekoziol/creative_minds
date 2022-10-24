import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/models/user.dart';

abstract class IDBRepo {
  // User
  Future<void> addUser(User user);
  Future<User?> getUser(String id);
  Future<void> updateUser(User user);

  // Posts
  Future<void> addPost(Post post);
  Future<List<Post>?> getAllPosts();
  Future<List<Post>?> getUserPosts(String userID);

  // Comments
  Future<List<Comment>?> getComments(String postID);
  Future<void> addComment(Comment comment);
}
