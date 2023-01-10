import 'package:flutter/material.dart';
import 'package:yotifiy/core/theme/color.dart';
import 'package:yotifiy/core/theme/space.dart';
import 'package:yotifiy/core/theme/text.dart';

class YFThemeData {
  final YFTextTheme textTheme;
  final YFColorTheme colorTheme;
  final YFSpaceTheme spaceTheme;

  YFThemeData({
    YFTextTheme? textTheme,
    YFColorTheme? colorTheme,
    YFSpaceTheme? spaceTheme,
  })  : textTheme = textTheme ?? YFTextTheme(),
        colorTheme = colorTheme ?? YFColorTheme.light,
        spaceTheme = spaceTheme ?? const YFSpaceTheme();

  factory YFThemeData.fromContext(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return YFThemeData(
      colorTheme: isDark ? YFColorTheme.dark : YFColorTheme.light,
    );
  }
}