import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/controllers/auth_controller.dart';
import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/new_post/new_post_view.dart';
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
        Text('Creative Minds', style: textTheme.headline5),
        Consumer(
          builder: (_, ref, __) {
            final user = ref.watch(authControllerProvider);
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
                CircleAvatar(
                  radius: Insets.s,
                  backgroundImage: NetworkImage(
                    user.photoURL ?? kBlankProfilePictureURL,
                  ),
                  backgroundColor: Colors.transparent,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}