import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/providers/posts_providers.dart';
import 'package:creative_minds/view/widgets/custom_app_bar.dart';
import 'package:creative_minds/view/widgets/post_card.dart';
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
          padding: const EdgeInsets.fromLTRB(Insets.m, Insets.s, Insets.m, 0),
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(height: Insets.xl),
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
                            return PostCard(
                              post: posts[index],
                              type: PostCardType.comments,
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
