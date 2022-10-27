import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/providers/posts_stream_provider.dart';
import 'package:creative_minds/view/comments/comments_view.dart';
import 'package:creative_minds/view/posts/widgets/post_card.dart';
import 'package:creative_minds/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.m),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Insets.s,
                ),
                child: CustomAppBar(),
              ),
              Expanded(
                child: Center(
                  child: Consumer(
                    builder: (_, ref, __) {
                      final posts = ref.watch(postsStreamProvider);

                      return posts.when(
                        loading: () => const CircularProgressIndicator(),
                        data: (posts) => ListView.separated(
                          itemCount: posts.length,
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  CommentsView.route,
                                  arguments: posts[index],
                                );
                              },
                              child: PostCard(post: posts[index]),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Insets.s),
                        ),
                        error: (_, __) => const Text(
                          'There was an error.\nPlease refresh the page.,',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
