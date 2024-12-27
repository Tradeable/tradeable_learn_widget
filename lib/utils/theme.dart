import 'package:flutter/material.dart';

class CustomStyles {
  final TextStyle smallNormal;
  final TextStyle smallBold;
  final TextStyle mediumNormal;
  final TextStyle mediumBold;
  final TextStyle largeNormal;
  final TextStyle largeBold;

  CustomStyles({
    required Color textColor,
    required double smallSize,
    required double mediumSize,
    required double largeSize,
  })  : smallNormal = TextStyle(
          fontSize: smallSize,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        smallBold = TextStyle(
          fontSize: smallSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        mediumNormal = TextStyle(
          fontSize: mediumSize,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        mediumBold = TextStyle(
          fontSize: mediumSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        largeNormal = TextStyle(
          fontSize: largeSize,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        largeBold = TextStyle(
          fontSize: largeSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        );
}

class CustomColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color borderColorPrimary;
  final Color borderColorSecondary;
  final Color cardColorPrimary;
  final Color cardColorSecondary;
  final Color bullishColor;
  final Color bearishColor;
  final Color selectedItemColor;
  final Color axisColor;
  final Color sipColor;
  final Color lumpSumColor;
  final Color cardBasicBackground;
  final Color buttonColor;
  final Color buttonBorderColor;

  CustomColors(
      {required this.primary,
      required this.secondary,
      required this.background,
      required this.borderColorPrimary,
      required this.borderColorSecondary,
      required this.cardColorPrimary,
      required this.cardColorSecondary,
      required this.bullishColor,
      required this.bearishColor,
      required this.selectedItemColor,
      required this.axisColor,
      required this.sipColor,
      required this.lumpSumColor,
      required this.cardBasicBackground,
      required this.buttonColor,
      required this.buttonBorderColor});
}

extension ThemeDataExtension on ThemeData {
  CustomColors get customColors {
    if (brightness == Brightness.light) {
      return CustomColors(
          primary: const Color(0xff97144D),
          secondary: const Color(0xffB4B4B4),
          background: Colors.transparent,
          borderColorPrimary: const Color(0xffED1164),
          borderColorSecondary: const Color(0xffB4B4B4),
          cardColorPrimary: const Color(0xffF9EBEF),
          cardColorSecondary: const Color(0xffe2e2e2),
          bullishColor: Colors.green,
          bearishColor: Colors.red,
          selectedItemColor: const Color(0xffF9B0CC),
          axisColor: Colors.black,
          sipColor: Colors.orangeAccent,
          lumpSumColor: Colors.blueAccent,
          cardBasicBackground: Colors.white,
          buttonColor: const Color(0xffF9F9F9),
          buttonBorderColor: const Color(0xffE2E2E2));
    } else {
      return CustomColors(
          primary: const Color(0xff38EB54),
          secondary: const Color(0xffB4B4B4),
          // background: const Color(0xFF161A26),
          background: Colors.transparent,
          borderColorPrimary: const Color(0xff5E6FA5),
          borderColorSecondary: const Color(0xffE3A85B),
          cardColorPrimary: const Color(0xff222838),
          cardColorSecondary: const Color(0xFF463B32),
          bullishColor: Colors.green,
          bearishColor: Colors.red,
          selectedItemColor: Colors.purple,
          axisColor: Colors.white,
          sipColor: Colors.orangeAccent,
          lumpSumColor: Colors.blueAccent,
          cardBasicBackground: Colors.black,
          buttonColor: Colors.white,
          buttonBorderColor: Colors.white38);
    }
  }

  CustomStyles get customTextStyles {
    final textColor =
        brightness == Brightness.light ? Colors.black : Colors.white;

    return CustomStyles(
      textColor: textColor,
      smallSize: 14.0,
      mediumSize: 18.0,
      largeSize: 24.0,
    );
  }
}
