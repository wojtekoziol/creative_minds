import 'package:creative_minds/data/providers/posts_stream_provider.dart';
import 'package:creative_minds/view/posts/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, ref, __) {
          final posts = ref.watch(postsStreamProvider);
          return posts.when(
            loading: () => const CircularProgressIndicator(),
            data: (posts) => ListView.builder(
              itemCount: posts.length,
              itemBuilder: (_, index) {
                if (posts.isEmpty) {
                  return const Text('No posts yet.');
                }
                return PostCard(post: posts[index]);
              },
            ),
            error: (_, __) => Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('There was an error.'),
                Text('Please refresh the page.'),
              ],
            ),
          );
        },
      ),
    );
  }
}
