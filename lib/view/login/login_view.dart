import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/controllers/auth_controller.dart';
import 'package:creative_minds/view/login/widgets/login_text_field.dart';
import 'package:creative_minds/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  static const route = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final mailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.m),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, -0.3),
                    child: Text(
                      'Join Creative Minds,\nnow!',
                      style: textTheme.headline4,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.5),
                    child: _LoginForm(
                      formKey: formKey,
                      mailController: mailController,
                      passwordController: passwordController,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: Insets.s),
                        child: IconButton(
                          onPressed: Navigator.of(context).pop,
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Insets.s),
                        child: _LoginButtons(
                          formKey: formKey,
                          mailController: mailController,
                          passwordController: passwordController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.mailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController mailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoginTextField(
            controller: mailController,
            hintText: 'mail',
            validator: (text) {
              if (text == null || !text.contains('@') || !text.contains('.')) {
                return 'Mail is invalid';
              }
              return null;
            },
          ),
          const SizedBox(height: Insets.m),
          LoginTextField(
            controller: passwordController,
            hintText: 'password',
            obscureText: true,
            validator: (text) {
              if (text == null || text.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class _LoginButtons extends ConsumerWidget {
  const _LoginButtons({
    required this.formKey,
    required this.mailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController mailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final authController = ref.read(authControllerProvider.notifier);
            final isSignedUp = await authController.signUpWithEmailAndPassword(
              email: mailController.text,
              password: passwordController.text,
            );
            if (isSignedUp) {
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar(
                'Account already exists or password is too weak',
              ));
            }
          },
          child: const Text('Sign up'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final authController = ref.read(authControllerProvider.notifier);
            final isSignedIn = await authController.signInWithEmailAndPassword(
              email: mailController.text,
              password: passwordController.text,
            );
            if (isSignedIn) {
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar(
                'Incorrect mail or password',
              ));
            }
          },
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}
