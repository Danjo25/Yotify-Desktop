import 'package:flutter/material.dart';
import 'package:yotifiy/core/theme/color.dart';
import 'package:yotifiy/core/theme/data.dart';
import 'package:yotifiy/core/theme/space.dart';
import 'package:yotifiy/core/theme/text.dart';
import 'package:yotifiy/core/theme/widget.dart';
import 'package:yotifiy/main.dart';

extension YFBuildContextExtension on BuildContext {
  YFThemeData get theme {
    try {
      return YFTheme.of(this);
    } catch (_) {
      final data = YFApp.themeKey.currentState?.data;

      if (data == null) {
        throw Exception('No parent widget of type YFTheme found');
      }

      return data;
    }
  }

  YFTextTheme get textTheme => theme.textTheme;

  YFColorTheme get colorTheme => theme.colorTheme;

  YFSpaceTheme get spaceTheme => theme.spaceTheme;
  
  Size get screenSize => MediaQuery.of(this).size;
}
