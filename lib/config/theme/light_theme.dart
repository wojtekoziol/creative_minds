import 'package:creative_minds/config/insets.dart';
import 'package:creative_minds/config/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light(
    primary: kTeal,
    secondary: kGraphite,
  ),
  textTheme: GoogleFonts.montserratTextTheme(const TextTheme(
    headline4: TextStyle(color: Colors.black),
    headline5: TextStyle(color: Colors.black),
    headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    subtitle1: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    subtitle2: TextStyle(color: kTeal),
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.black),
  )),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kTeal,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Insets.xs),
      ),
    ),
  ),
  dividerColor: kLightGrey,
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Insets.s),
    ),
  ),
);
