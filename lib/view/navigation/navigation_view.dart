import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/controllers/auth_controller.dart';
import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/posts/posts_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: const [
            PostsView(),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Insets.m,
                  vertical: Insets.s,
                ),
                child: _AppBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Creative Minds', style: textTheme.headline6),
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
                  onPressed: () {},
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
