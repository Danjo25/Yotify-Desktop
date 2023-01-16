import 'package:flutter/material.dart';
import 'package:yotifiy/core/theme/color.dart';
import 'package:yotifiy/core/theme/text.dart';

abstract class YFTypography {
  static const YFTextTheme standard = YFTextTheme.raw(
    headline1: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: YFColorTheme.white,
    ),
    headline2: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: YFColorTheme.white,
    ),
    headline3: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: YFColorTheme.white,
    ),
    headline4: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: YFColorTheme.white,
    ),
    headline5: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: YFColorTheme.white,
    ),
    body1: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 40,
      fontWeight: FontWeight.w400,
      color: YFColorTheme.white,
    ),
    body2: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: YFColorTheme.white,
    ),
    body3: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: YFColorTheme.white,
      
    ),
    subtitle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: YFColorTheme.white,
    ),
  );

  YFTypography._();
}
