import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/controllers/auth_controller.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:creative_minds/view/new_post/widgets/post_text_field.dart';
import 'package:creative_minds/view/widgets/custom_card.dart';
import 'package:creative_minds/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewPostView extends HookConsumerWidget {
  const NewPostView({super.key});

  static const route = '/new_post';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final textController = useTextEditingController();

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
                    child: CustomCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create a new post', style: textTheme.headline6),
                          const SizedBox(height: Insets.s),
                          const Text('Description'),
                          const SizedBox(height: Insets.xs),
                          PostTextField(controller: textController),
                          const SizedBox(height: Insets.m),
                          Align(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final userID =
                                      ref.read(authControllerProvider)?.uid;
                                  if (userID == null) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackbar('User not found'),
                                    );
                                    return;
                                  }
                                  final firestoreRepo =
                                      ref.read(firestoreRepoProvider);
                                  await firestoreRepo.addPost(Post(
                                    id: '',
                                    userID: userID,
                                    text: textController.text,
                                  ));
                                  Navigator.of(context).pop();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Insets.xs,
                                  ),
                                  child: Text('Submit'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
