import 'package:creative_minds/config/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light(
    primary: kTeal,
    secondary: kGraphite,
  ),
  textTheme: GoogleFonts.montserratTextTheme(),
);
