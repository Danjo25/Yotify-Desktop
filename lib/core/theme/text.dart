import 'package:flutter/material.dart';
import 'package:yotifiy/core/theme/typography.dart';

class YFTextTheme {
  final TextStyle headline1;
  final TextStyle headline2;
  final TextStyle headline3;
  final TextStyle headline4;
  final TextStyle headline5;
  final TextStyle body1;
  final TextStyle body2;
  final TextStyle subtitle;

  const YFTextTheme.raw({
    required this.headline1,
    required this.headline2,
    required this.headline3,
    required this.headline4,
    required this.headline5,
    required this.body1,
    required this.body2,
    required this.subtitle,
  });

  factory YFTextTheme() => YFTypography.standard;

  YFTextTheme copyWith({
    TextStyle? headline1,
    TextStyle? headline2,
    TextStyle? headline3,
    TextStyle? headline4,
    TextStyle? headline5,
    TextStyle? body1,
    TextStyle? body2,
    TextStyle? button,
    TextStyle? subtitle,
  }) =>
      YFTextTheme.raw(
        headline1: headline1 ?? this.headline1,
        headline2: headline2 ?? this.headline2,
        headline3: headline3 ?? this.headline3,
        headline4: headline4 ?? this.headline4,
        headline5: headline5 ?? this.headline5,
        body1: body1 ?? this.body1,
        body2: body2 ?? this.body2,
        subtitle: subtitle ?? this.subtitle,
      );
}
