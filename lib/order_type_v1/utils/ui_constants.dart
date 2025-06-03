import 'package:flutter/material.dart';

class UIConstants {
  // Colors
  static const Color primaryCardColor = Color(0xFFEBF0F9);
  static const Color secondaryCardColor = Color(0xFFE2E2E2);
  static const Color labelBackgroundColor = Color(0xFFF9F6EB);
  static const Color textFieldBackgroundColor = Color(0xFF395046);
  static const Color textFieldAccentColor = Color(0xFF2BC381);
  static const Color textFieldIconColor = Color(0xFFD3CABD);
  static const Color primaryTextColor = Color(0xFF6E6E6E);
  static const Color primaryButtonColor = Color(0xFF97144D);
  static const Color switchActiveColor = Color(0xFF12877F);
  static const Color switchInactiveColor = Color(0xFF97144D);

  // Text Styles
  static const TextStyle stockNameStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Color(0xFF6E6E6E),
  );

  static const TextStyle instructionLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6E6E6E),
  );

  static const TextStyle instructionTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Color(0xFF6E6E6E),
  );

  static const TextStyle buyButtonStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle advancedOptionsStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Color(0xFF6E6E6E),
  );

  static const TextStyle textFieldStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle pillboxBaseStyle = TextStyle(
    fontWeight: FontWeight.w600,
  );

// Style methods for pillbox (instead of static styles)
  static TextStyle getPillboxSelectedStyle({
    double? fontSize,
    bool enabled = true,
  }) =>
      pillboxBaseStyle.copyWith(
        fontSize: fontSize ?? 14,
        color: enabled ? Colors.white : Colors.grey,
      );

  static TextStyle getPillboxUnselectedStyle({
    double? fontSize,
    bool enabled = true,
  }) =>
      pillboxBaseStyle.copyWith(
        fontSize: fontSize ?? 14,
        color: enabled ? const Color(0xFF6E6E6E) : Colors.grey,
      );

  static const TextStyle marginTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6E6E6E),
  );

  // Dimensions, Animation, Layout (same as before)
  static const double defaultBorderRadius = 15.0;
  static const double smallBorderRadius = 8.0;
  static const double labelBorderRadius = 16.0;
  static const double switchBorderRadius = 20.0;

  static const EdgeInsets defaultPadding = EdgeInsets.all(8.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets fieldPadding =
      EdgeInsets.symmetric(horizontal: 4, vertical: 4);

  static const Duration defaultAnimationDuration = Duration(milliseconds: 400);
  static const Duration switchAnimationDuration = Duration(milliseconds: 200);
  static const Duration tutorialInitDelay = Duration(milliseconds: 100);

  static const double minButtonHeight = 50.0;
  static const double minIconSize = 18.0;
  static const double minFieldSize = 32.0;

  static double getResponsiveWidth(BuildContext context, double multiplier) =>
      MediaQuery.of(context).size.width * multiplier;

  static double getResponsiveHeight(BuildContext context, double multiplier) =>
      MediaQuery.of(context).size.height * multiplier;
}
