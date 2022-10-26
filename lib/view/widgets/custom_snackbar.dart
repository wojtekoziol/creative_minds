import 'package:creative_minds/config/insets.dart';
import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar(String text, {super.key})
      : super(
          content: Text(text),
          margin: const EdgeInsets.fromLTRB(Insets.s, 0, Insets.s, Insets.s),
        );
}
