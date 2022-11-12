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
    this.multiline = false,
    this.counter = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool obscureText;
  final String? Function(String? text)? validator;
  final bool multiline;
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
      keyboardType: multiline ? TextInputType.multiline : null,
      maxLines: multiline ? 10 : null,
      minLines: multiline ? 10 : null,
      maxLength: multiline ? 300 : null,
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
