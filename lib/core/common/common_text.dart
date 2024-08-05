import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common_color.dart';

class CommonText {
  //heading
  static final TextStyle fHeading1 = GoogleFonts.urbanist(
      fontSize: 40,
      color: CommonColor.labelTextColor,
      fontWeight: FontWeight.w700);
  static final TextStyle fHeading2 = GoogleFonts.urbanist(
      fontSize: 28,
      color: CommonColor.labelTextColor,
      fontWeight: FontWeight.w700);
  static final TextStyle fHeading3 = GoogleFonts.urbanist(
      fontSize: 22,
      color: CommonColor.labelTextColor,
      fontWeight: FontWeight.w700);
  static final TextStyle fHeading4 = GoogleFonts.urbanist(
      fontSize: 20,
      color: CommonColor.labelTextColor,
      fontWeight: FontWeight.w700);
  static final TextStyle fHeading5 = GoogleFonts.urbanist(
      fontSize: 18,
      color: CommonColor.labelTextColor,
      fontWeight: FontWeight.w700);

  //body
  static final TextStyle fBodyLarge =
      GoogleFonts.urbanist(fontSize: 16, color: CommonColor.labelTextColor);
  static final TextStyle fBodySmall =
      GoogleFonts.urbanist(fontSize: 14, color: CommonColor.labelTextColor);

  //caption
  static final TextStyle fCaptionLarge =
      GoogleFonts.urbanist(fontSize: 12, color: CommonColor.labelTextColor);
  static final TextStyle fCaptionSmall =
      GoogleFonts.urbanist(fontSize: 10, color: CommonColor.labelTextColor);
}
