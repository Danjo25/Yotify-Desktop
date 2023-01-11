import 'package:flutter/material.dart';
import 'package:yotifiy/core/theme/data.dart';

class YFTheme extends StatefulWidget {
  final Widget child;
  final YFThemeData data;

  const YFTheme({
    super.key,
    required this.child,
    required this.data,
  });

  @override
  State<YFTheme> createState() => YFThemeState();

  static YFThemeData of(BuildContext context) {
    final data = context
        .dependOnInheritedWidgetOfExactType<_InheritedTheme>()
        ?.theme
        .data;

    if (data == null) {
      throw Exception('No parent widget of type YFTheme found');
    }

    return data;
  }
}

class YFThemeState extends State<YFTheme> {
  YFThemeData get data => widget.data;

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: widget,
      child: widget.child,
    );
  }
}

class _InheritedTheme extends InheritedWidget {
  final YFTheme theme;

  const _InheritedTheme({
    required this.theme,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedTheme oldWidget) =>
      oldWidget.theme.data != theme.data;
}
