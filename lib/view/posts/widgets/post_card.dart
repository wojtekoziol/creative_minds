import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(Insets.s),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.m,
          vertical: Insets.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<User?>(
              future: ref.read(firestoreRepoProvider).getUser(post.userID),
              builder: (context, snapshot) {
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
                  'An error occurred',
                  style: theme.textTheme.subtitle1,
                );
              },
            ),
            const SizedBox(height: Insets.l),
            Text(post.text, style: theme.textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
