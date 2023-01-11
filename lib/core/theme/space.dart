import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YFSpaceTheme {
  static const double _defaultRem = 8;
  static const defaultAvatarSize = 43.0;
  static const homeWidgetsWidth = 160;

  final double rem;

  const YFSpaceTheme([this.rem = _defaultRem]);

  double get padding05 => rem * 0.5;
  double get padding1 => rem;
  double get padding2 => rem * 2;
  double get padding3 => rem * 3;
  double get padding4 => rem * 4;
  double get padding5 => rem * 5;
  double get scrollSafeButtonPadding => rem * 12;
  double get defaultElevation => rem;

  double get chatMessagesMinHeight => padding5;

  Widget fixedSpace([double scale = 1]) {
    final size = rem * scale;

    return SizedBox.fromSize(size: Size.square(size));
  }

  static getActualDefaultAvatarSize([bool isScaled = true]) =>
      isScaled ? defaultAvatarSize.sp : defaultAvatarSize;
}
