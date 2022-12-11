import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/models/user.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:creative_minds/view/widgets/custom_snackbar.dart';
import 'package:creative_minds/view/widgets/custom_text_form_field.dart';
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
          CustomTextFormField(
            type: TextInputType.emailAddress,
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
          CustomTextFormField(
            type: TextInputType.visiblePassword,
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
            try {
              final credentials = await ref
                  .read(firebaseAuthProvider)
                  .createUserWithEmailAndPassword(
                    email: mailController.text,
                    password: passwordController.text,
                  );
              if (credentials.user == null || credentials.user!.email == null) {
                return;
              }
              final user = User(
                id: credentials.user!.uid,
                email: credentials.user!.email!,
              );
              await ref.read(firestoreRepoProvider).addUser(user);
              Navigator.of(context).pop();
            } on FirebaseException {
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
            try {
              await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
                    email: mailController.text,
                    password: passwordController.text,
                  );
              Navigator.of(context).pop();
            } on FirebaseException {
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
