import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postControllerProvider = Provider(PostController.new);

class PostController extends StateNotifier<List<Post>?> {
  PostController(this._ref) : super(null);

  final Ref _ref;

  Future<void> getAllPosts() async {
    final posts = await _ref.read(firestoreRepoProvider).getAllPosts();
    state = posts;
  }
}
