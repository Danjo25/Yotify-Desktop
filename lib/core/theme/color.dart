import 'package:flutter/material.dart';

class YFColorTheme {
  static const avatarColors = [
    Color(0xFF7A84E7),
    Color(0xFF163C44),
    Color(0xFF3F85CA),
    Color(0xFFBD66A3),
    Color(0xFF2F671E),
  ];
  static const white = Color(0xFFF3F7FD);
  static const green = Color(0xFF00B6AB);
  static const red = Color(0xFFEE7569);
  static const orange = Color(0xFFED9B0C);
  static const black = Colors.black;
  static const grey = Color.fromARGB(151, 212, 212, 212);

  static const YFColorTheme light = YFColorTheme.raw(
    primary: green,
    text1: Color(0xFF0D1521),
    text2: Color(0xFF0D1521),
    hint: Color.fromARGB(151, 212, 212, 212),
    background1: Color(0xFFF2F5FC),
    background2: Color.fromARGB(255, 222, 222, 222),
    background3: Color(0x10FFFFFF),
    background4: Color(0xFFF3F7FD),
    border: Color(0xFFEAEEF6),
    error: red,
    warning: orange,
    barrier: Color(0x8A000000),
  );

  static const YFColorTheme dark = YFColorTheme.raw(
    primary: green,
    text1: white,
    text2: Color(0xFFC9C9C9),
    hint: Color.fromARGB(255, 187, 187, 187),
    background1: Color(0xFF141414),
    background2: Color(0xFF222222),
    background3: Color(0xFF464646),
    background4: Color(0xFF292929),
    border: Color(0xFF222222),
    error: red,
    warning: orange,
    barrier: Color(0x8A000000),
  );

  static Color getAvatarColor(int index) =>
      avatarColors[index % avatarColors.length];

  final Color primary;
  final Color text1;
  final Color text2;
  final Color hint;
  final Color background1;
  final Color background2;
  final Color background3;
  final Color background4;
  final Color border;
  final Color error;
  final Color warning;
  final Color barrier;

  const YFColorTheme.raw({
    required this.primary,
    required this.text1,
    required this.text2,
    required this.hint,
    required this.background1,
    required this.background2,
    required this.background3,
    required this.background4,
    required this.border,
    required this.error,
    required this.warning,
    required this.barrier,
  });

  YFColorTheme copyWith({
    Color? primary,
    Color? text1,
    Color? text2,
    Color? hint,
    Color? background1,
    Color? background2,
    Color? background3,
    Color? background4,
    Color? border,
    Color? error,
    Color? warning,
    Color? barrier,
  }) =>
      YFColorTheme.raw(
        primary: primary ?? this.primary,
        text1: text1 ?? this.text1,
        text2: text2 ?? this.text2,
        hint: hint ?? this.hint,
        background1: background1 ?? this.background1,
        background2: background2 ?? this.background2,
        background3: background3 ?? this.background3,
        background4: background4 ?? this.background4,
        border: border ?? this.border,
        error: error ?? this.error,
        warning: warning ?? this.warning,
        barrier: barrier ?? this.barrier,
      );
}
