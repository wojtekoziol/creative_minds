import 'package:creative_minds/config/insets.dart';
import 'package:flutter/material.dart';

class CommentTextField extends StatelessWidget {
  const CommentTextField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Insets.xs),
        ),
        hintText: 'Leave a comment',
        hintStyle: theme.textTheme.bodyText1,
      ),
      style: theme.textTheme.bodyText1,
    );
  }
}
