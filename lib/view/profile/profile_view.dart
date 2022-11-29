import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creative_minds/config/constants.dart';
import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/providers/app_providers.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:creative_minds/data/providers/posts_providers.dart';
import 'package:creative_minds/data/providers/user_providers.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:creative_minds/view/login/login_view.dart';
import 'package:creative_minds/view/widgets/custom_app_bar.dart';
import 'package:creative_minds/view/widgets/custom_snackbar.dart';
import 'package:creative_minds/view/widgets/custom_text_form_field.dart';
import 'package:creative_minds/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({super.key});

  static const route = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final focusNode = useFocusNode();
    final animController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    useEffect(() {
      nameController
        ..text = ref.read(currentUserStreamProvider).value?.name ?? ''
        ..addListener(() {
          nameController.text == ref.read(currentUserStreamProvider).value?.name
              ? animController.reverse()
              : animController.forward();
        });
      return;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.m, Insets.s, Insets.m, 0),
            child: Column(
              children: [
                const SafeArea(
                  bottom: false,
                  child: CustomAppBar(),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _YourProfileSection(
                        controller: nameController,
                        focusNode: focusNode,
                      ),
                      const SizedBox(height: Insets.xl),
                      const _PostsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: Insets.s, right: Insets.m),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0, end: 1)
                      .chain(CurveTween(curve: Curves.fastOutSlowIn))
                      .animate(animController),
                  child: ElevatedButton(
                    onPressed: () {
                      final user = ref.read(currentUserStreamProvider).value;
                      if (user == null) return;
                      ref
                          .read(firestoreRepoProvider)
                          .updateUser(user.copyWith(name: nameController.text));
                      animController.reverse();
                      focusNode.unfocus();
                    },
                    child: const Text('Change username'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YourProfileSection extends ConsumerWidget {
  const _YourProfileSection({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your profile', style: textTheme.subtitle2),
          const SizedBox(height: Insets.s),
          ref.watch(currentUserStreamProvider).when(
                data: (user) => Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: Insets.m,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            user?.photoURL ?? kBlankProfilePictureURL,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final picker = ref.read(imagePickerProvider);
                            final file = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (file == null || user == null) return;
                            try {
                              final storage =
                                  ref.read(firebaseStorageProvider(user.id));
                              await storage.putFile(File(file.path));
                              await ref
                                  .read(firestoreRepoProvider)
                                  .updateUser(user.copyWith(
                                    photoURL: await storage.getDownloadURL(),
                                  ));
                            } on FirebaseException {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar(
                                  'An error ocurred. Try again later.',
                                ),
                              );
                            }
                          },
                          child: const Opacity(
                            opacity: 0.25,
                            child: CircleAvatar(
                              radius: Insets.m,
                              backgroundColor: Colors.black,
                              child: Icon(Icons.edit_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: Insets.s),
                    Expanded(
                      child: CustomTextFormField(
                        type: TextInputType.name,
                        controller: controller,
                        focusNode: focusNode,
                        hintText: user?.name,
                      ),
                    ),
                  ],
                ),
                error: (_, __) => const Text('Could not load your profile'),
                loading: () => const Text('Loading...'),
              ),
          const SizedBox(height: Insets.m),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                ..popUntil((route) => route.isFirst)
                ..pushNamed(LoginView.route);
              ref.read(firebaseAuthProvider).signOut();
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _PostsSection extends ConsumerWidget {
  const _PostsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your posts', style: textTheme.subtitle2),
          const SizedBox(height: Insets.s),
          ref.watch(userPostsStreamProvider).when(
                data: (posts) => Column(
                  children: [
                    for (final post in posts) ...[
                      PostCard(
                        post: post,
                        type: PostCardType.edit,
                      ),
                      const SizedBox(height: Insets.s),
                    ]
                  ],
                ),
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text('Could not load your posts.'),
              ),
        ],
      ),
    );
  }
}
