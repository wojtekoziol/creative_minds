import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/navigation/navigation_view.dart';
import 'package:creative_minds/view/new_post/new_post_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationView.route:
        return MaterialPageRoute(builder: (_) => const NavigationView());

      case LoginView.route:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginView(),
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

      case NewPostView.route:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const NewPostView(),
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

    return MaterialPageRoute(builder: (_) => const NavigationView());
  }
}
