import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/providers/user_providers.dart';
import 'package:creative_minds/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerWidget {
  const CommentCard(this.comment, {super.key});

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ref.watch(userStreamProvider(comment.userID)).when(
                data: (user) => Row(
                  children: [
                    CircleAvatar(
                      radius: Insets.s,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        user?.photoURL ?? kBlankProfilePictureURL,
                      ),
                    ),
                    const SizedBox(width: Insets.s),
                    Text(
                      user?.name ?? 'user',
                      style: theme.textTheme.subtitle1,
                    ),
                  ],
                ),
                error: (_, __) => Text(
                  "Could not get user's name",
                  style: theme.textTheme.subtitle1,
                ),
                loading: () => Text(
                  'Loading...',
                  style: theme.textTheme.subtitle1,
                ),
              ),
          const SizedBox(height: Insets.l),
          Text(comment.text),
        ],
      ),
    );
  }
}
