import 'package:flutter/material.dart';
import 'package:yotifiy/core/theme/text.dart';

abstract class YFTypography {
  static const YFTextTheme standard = YFTextTheme.raw(
    headline1: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    headline5: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    body1: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    body2: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    subtitle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );

  YFTypography._();
}
