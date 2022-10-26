import 'package:creative_minds/config/insets.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(Insets.s),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.m,
          vertical: Insets.s,
        ),
        child: child,
      ),
    );
  }
}
