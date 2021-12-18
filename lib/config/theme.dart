import 'package:countdown/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: darkBackgroundColor),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: darkBackgroundColor,
      fontFamily: GoogleFonts.montserrat().fontFamily,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: darkBackgroundColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: Colors.white,
      fontFamily: GoogleFonts.montserrat().fontFamily,
    ),
  );
}
