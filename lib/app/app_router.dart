import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/view/comments/comments_view.dart';
import 'package:creative_minds/view/error/error_view.dart';
import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/new_post/new_post_view.dart';
import 'package:creative_minds/view/posts/posts_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PostsView.route:
        return MaterialPageRoute(builder: (_) => const PostsView());

      case LoginView.route:
        return _slideUpTransition(const LoginView());

      case NewPostView.route:
        return _slideUpTransition(const NewPostView());

      case CommentsView.route:
        final args = settings.arguments;
        return _slideUpTransition(args == null
            ? const ErrorView()
            : CommentsView(post: args as Post));
    }

    return _slideUpTransition(const ErrorView());
  }
}

PageRouteBuilder<dynamic> _slideUpTransition(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      );
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
