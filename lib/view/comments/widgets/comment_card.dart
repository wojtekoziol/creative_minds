import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
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
          FutureBuilder<User?>(
            future: ref.read(firestoreRepoProvider).getUser(comment.userID),
            builder: (context, snapshot) {
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
          Text(comment.text),
        ],
      ),
    );
  }
}
