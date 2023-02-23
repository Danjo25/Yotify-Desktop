import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

const colorWindowButtons = Color(0xffcccccc);
const colorWindowButtonsBackgroundClick = Color.fromARGB(136, 204, 204, 204);
const colorWindowButtonsBackgroundHover = Color.fromARGB(50, 204, 204, 204);
const colorWindowButtonClose = Color(0xffd71526);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
            colors: WindowButtonColors(
                iconNormal: colorWindowButtons,
                mouseOver: colorWindowButtonsBackgroundHover,
                mouseDown: colorWindowButtonsBackgroundClick)),
        MaximizeWindowButton(
            colors: WindowButtonColors(
                iconNormal: colorWindowButtons,
                mouseOver: colorWindowButtonsBackgroundHover,
                mouseDown: colorWindowButtonsBackgroundClick)),
        CloseWindowButton(
            colors: WindowButtonColors(
                iconNormal: colorWindowButtons,
                mouseOver: colorWindowButtonClose,
                mouseDown: colorWindowButtonClose)),
      ],
    );
  }
}
