import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/data/models/comment.dart';
import 'package:creative_minds/data/models/post.dart';
import 'package:creative_minds/data/providers/comments_providers.dart';
import 'package:creative_minds/data/providers/firebase_providers.dart';
import 'package:creative_minds/data/repositories/firestore_repo.dart';
import 'package:creative_minds/view/comments/widgets/comment_card.dart';
import 'package:creative_minds/view/widgets/custom_text_form_field.dart';
import 'package:creative_minds/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommentsView extends HookConsumerWidget {
  const CommentsView({super.key, required this.post});

  static const route = '/comments';

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.m, Insets.s, Insets.m, 0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.close),
              ),
              const SizedBox(height: Insets.xl),
              PostCard(post: post),
              const SizedBox(height: Insets.xl),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      type: TextInputType.text,
                      controller: textController,
                      focusNode: textFieldFocusNode,
                      hintText: 'Leave a comment',
                    ),
                  ),
                  const SizedBox(width: Insets.m),
                  ElevatedButton(
                    onPressed: () async {
                      if (textController.text.isEmpty) return;
                      final userID = ref
                          .watch(currentFirebaseUserStreamProvider)
                          .value
                          ?.uid;
                      if (userID == null) return;
                      final comment = Comment(
                        id: '',
                        postID: post.id,
                        userID: userID,
                        text: textController.text,
                      );
                      await ref.read(firestoreRepoProvider).addComment(comment);
                      textController.clear();
                      textFieldFocusNode.unfocus();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: Insets.s),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.xl),
              Expanded(
                child: Center(
                  child: Consumer(
                    builder: (_, ref, __) {
                      final comments =
                          ref.watch(commentsStreamProvider(post.id));
                      return comments.when(
                        loading: () => const CircularProgressIndicator(),
                        data: (comments) => ListView.separated(
                          itemCount: comments.length,
                          padding: const EdgeInsets.only(bottom: Insets.s),
                          itemBuilder: (_, index) =>
                              CommentCard(comments[index]),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Insets.s),
                        ),
                        error: (_, __) => const Text(
                          'There was an error.\nPlease refresh the page.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
