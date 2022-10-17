import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/models/post.dart';

abstract class IDBRepo {
  Future<List<Post>?> getAllPosts();
  Future<List<Post>?> getUserPosts(String authorID);
  Future<List<Comment>?> getComments(String postID);
  Future<void> addPost(Post post);
  Future<void> addComment(Comment comment);
}
