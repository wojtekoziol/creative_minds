import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:creative_minds/data/providers/posts_providers.dart';
import 'package:creative_minds/data/providers/user_providers.dart';
import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/widgets/custom_app_bar.dart';
import 'package:creative_minds/view/widgets/post_card.dart';
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
                children: const [
                  _YourProfileSection(),
                  SizedBox(height: Insets.xl),
                  _PostsSection(),
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
          ref.watch(currentUserStreamProvider).when(
                data: (user) => Row(
                  children: [
                    CircleAvatar(
                      radius: Insets.m,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        user?.photoURL ?? kBlankProfilePictureURL,
                      ),
                    ),
                    const SizedBox(width: Insets.s),
                    Text(user?.name ?? 'user'),
                  ],
                ),
                error: (_, __) => const Text('Could not load your profile'),
                loading: () => const Text('Loading...'),
              ),
          const SizedBox(height: Insets.m),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                ..popUntil((route) => route.isFirst)
                ..pushNamed(LoginView.route);
              ref.read(firebaseAuthProvider).signOut();
            },
            child: const Text('Sign out'),
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
