import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xff16171D);
  static const Color primaryColor = Color(0xffD9B38C);
  // static const Color primaryColor = Color(0xffD9B38C);

  static TextStyle logoTextStyle = GoogleFonts.lato(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 40
  );
  static TextStyle headerStyle = GoogleFonts.lato(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 24
  );

  static TextStyle bodyText = GoogleFonts.lato(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 16
  );
  static TextStyle bodyTextLight = GoogleFonts.lato(
    color: const Color(0xff8a8b8e),
    fontWeight: FontWeight.w500,
    fontSize: 16
  );
  static TextStyle buttonStyle = GoogleFonts.lato(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 18
  );
}
