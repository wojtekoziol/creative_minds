import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:creative_minds/view/comments/comments_view.dart';
import 'package:creative_minds/view/new_post/new_post_view.dart';
import 'package:creative_minds/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PostCardType {
  empty,
  comments,
  edit,
}

class PostCard extends ConsumerWidget {
  const PostCard({
    super.key,
    required this.post,
    this.type = PostCardType.empty,
  });

  final Post post;
  final PostCardType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<User?>(
            future: ref.read(firestoreRepoProvider).getUser(post.userID),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  'An error occurred',
                  style: theme.textTheme.subtitle1,
                );
              }
              if (snapshot.hasData) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: Insets.s,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        snapshot.data?.photoURL ?? kBlankProfilePictureURL,
                      ),
                    ),
                    const SizedBox(width: Insets.s),
                    Text(
                      snapshot.data?.name ?? 'user',
                      style: theme.textTheme.subtitle1,
                    ),
                  ],
                );
              }
              return Text(
                'Loading...',
                style: theme.textTheme.subtitle1,
              );
            },
          ),
          const SizedBox(height: Insets.l),
          Text(post.text),
          if (type == PostCardType.comments) ...[
            const SizedBox(height: Insets.l),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CommentsView.route,
                  arguments: post,
                );
              },
              icon: Icon(
                Icons.comment_outlined,
                color: theme.colorScheme.primary,
              ),
              label: const Text('Comments'),
            ),
          ],
          if (type == PostCardType.edit) ...[
            const SizedBox(height: Insets.l),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  NewPostView.route,
                  arguments: post,
                );
              },
              icon: Icon(
                Icons.edit_outlined,
                color: theme.colorScheme.primary,
              ),
              label: const Text('Edit'),
            ),
          ]
        ],
      ),
    );
  }
}
