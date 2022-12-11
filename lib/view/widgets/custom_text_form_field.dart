import 'package:creative_minds/config/insets.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.obscureText = false,
    this.validator,
    required this.type,
    this.counter = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool obscureText;
  final String? Function(String? text)? validator;
  final TextInputType type;
  final bool counter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      validator: validator,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Insets.xs),
        ),
        hintText: hintText,
        hintStyle: theme.textTheme.bodyText1,
      ),
      obscureText: obscureText,
      autocorrect: false,
      style: theme.textTheme.bodyText1,
      keyboardType: type,
      maxLines: type == TextInputType.multiline ? 10 : 1,
      minLines: type == TextInputType.multiline ? 10 : 1,
      maxLength: type == TextInputType.multiline ? 300 : null,
      buildCounter: counter
          ? (context, {required currentLength, required isFocused, maxLength}) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$currentLength/$maxLength',
                  style: theme.textTheme.caption,
                ),
              );
            }
          : null,
    );
  }
}
