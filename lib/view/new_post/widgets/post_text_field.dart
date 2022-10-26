import 'package:creative_minds/config/insets.dart';
import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  const PostTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      minLines: 10,
      maxLength: 300,
      controller: controller,
      buildCounter: (context,
          {required currentLength, required isFocused, maxLength}) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$currentLength/$maxLength',
            style: theme.textTheme.subtitle2,
          ),
        );
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Insets.xs),
        ),
      ),
      style: theme.textTheme.bodyText1,
    );
  }
}
