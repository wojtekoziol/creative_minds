import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/controllers/auth_controller.dart';
import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/providers/posts_stream_provider.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/posts/widgets/post_card.dart';
import 'package:creative_minds/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  static const route = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.m, Insets.s, Insets.m, 0),
        child: Column(
          children: [
            const SafeArea(
              bottom: false,
              child: CustomAppBar(),
            ),
            Expanded(
              child: ListView(
                children: [
                  const _YourProfileSection(),
                  const SizedBox(height: Insets.m),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                        ..popUntil((route) => route.isFirst)
                        ..pushNamed(LoginView.route);
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                    child: const Text('Sign out'),
                  ),
                  const SizedBox(height: Insets.xl),
                  const _PostsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YourProfileSection extends ConsumerWidget {
  const _YourProfileSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your profile', style: textTheme.subtitle1),
          const SizedBox(height: Insets.s),
          FutureBuilder<User?>(
            future: ref
                .read(firestoreRepoProvider)
                .getUser(ref.watch(authControllerProvider)?.uid),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return const Text('Could not load your profile');
              }
              if (snapshot.hasData) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: Insets.m,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        snapshot.data?.photoURL ?? kBlankProfilePictureURL,
                      ),
                    ),
                    const SizedBox(width: Insets.s),
                    Text(snapshot.data?.name ?? 'user'),
                  ],
                );
              }
              return const Text('Loading...');
            },
          ),
        ],
      ),
    );
  }
}

class _PostsSection extends ConsumerWidget {
  const _PostsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your posts', style: textTheme.subtitle1),
          const SizedBox(height: Insets.s),
          ref.watch(userPostsStreamProvider).when(
                data: (posts) => Column(
                  children: [
                    for (final post in posts) ...[
                      PostCard(
                        post: post,
                        type: PostCardType.edit,
                      ),
                      const SizedBox(height: Insets.s),
                    ]
                  ],
                ),
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text('Could not load your posts.'),
              ),
        ],
      ),
    );
  }
}
