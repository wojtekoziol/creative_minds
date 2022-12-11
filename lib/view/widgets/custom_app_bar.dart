import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/providers/user_providers.dart';
import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/new_post/new_post_view.dart';
import 'package:creative_minds/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text('Creative Minds', style: textTheme.headline5),
        ),
        Consumer(
          builder: (_, ref, __) {
            final user = ref.watch(currentUserStreamProvider).value;
            if (user == null) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginView.route);
                },
                child: const Text('Join now'),
              );
            }
            return Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(NewPostView.route);
                  },
                  child: const Text('Post'),
                ),
                const SizedBox(width: Insets.s),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProfileView.route);
                  },
                  child: CircleAvatar(
                    radius: Insets.s,
                    backgroundImage: NetworkImage(
                      user.photoURL ?? kBlankProfilePictureURL,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
