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

class ThemeColors {
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
  final Color sliderColor;
  final Color textColorSecondary;
  final Color disabledContainer;
  final Color supportItemColor;

  ThemeColors({
    required this.primary,
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
    required this.buttonBorderColor,
    required this.sliderColor,
    required this.textColorSecondary,
    required this.disabledContainer,
    required this.supportItemColor,
  });

  // Light theme colors factory
  static ThemeColors light() {
    return ThemeColors(
      primary: const Color(0xff97144D),
      secondary: const Color(0xffB4B4B4),
      background: Colors.transparent,
      borderColorPrimary: const Color(0xffF14687),
      borderColorSecondary: const Color(0xffB4B4B4),
      cardColorPrimary: const Color(0xffF9EBEF),
      cardColorSecondary: const Color(0xffe2e2e2),
      bullishColor: const Color(0xff278829),
      bearishColor: Colors.red,
      selectedItemColor: const Color(0xffF9B0CC),
      axisColor: Colors.black,
      sipColor: Colors.orangeAccent,
      lumpSumColor: Colors.blueAccent,
      cardBasicBackground: Colors.white,
      buttonColor: const Color(0xffF9F9F9),
      buttonBorderColor: const Color(0xffE2E2E2),
      sliderColor: const Color(0xffED1164),
      textColorSecondary: const Color(0xff6E6E6E),
      disabledContainer: const Color(0xffB3BCB9),
      supportItemColor: const Color(0xff165964),
    );
  }

  // Dark theme colors factory
  static ThemeColors dark() {
    return ThemeColors(
      primary: const Color(0xff38EB54),
      secondary: const Color(0xffB4B4B4),
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
      buttonBorderColor: Colors.white38,
      sliderColor: const Color(0xffED1164),
      textColorSecondary: Colors.white,
      disabledContainer: const Color(0xffB3BCB9),
      supportItemColor: const Color(0xff165964),
    );
  }
}

extension ThemeDataExtension on ThemeData {
  ThemeColors get customColors {
    if (brightness == Brightness.light) {
      return ThemeColors.light();
    } else {
      return ThemeColors.dark();
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

/// AppTheme class to provide complete ThemeData for the application
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Creates a light theme based on CustomColors and CustomStyles
  static ThemeData lightTheme() {
    final customColors = ThemeColors.light();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: customColors.primary,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: customColors.primary,
        secondary: customColors.secondary,
        surface: customColors.cardBasicBackground,
        background: Colors.white,
        error: customColors.bearishColor,
      ),
      cardTheme: CardThemeData(
        color: customColors.cardBasicBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: customColors.borderColorSecondary,
            width: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: customColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: customColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: customColors.primary,
        unselectedItemColor: customColors.secondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: customColors.buttonColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: customColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: customColors.primary,
          side: BorderSide(color: customColors.buttonBorderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: customColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.borderColorSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.borderColorSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.bearishColor),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: customColors.sliderColor,
        inactiveTrackColor:
            customColors.sliderColor.withAlpha((0.3 * 255).round()),
        thumbColor: customColors.sliderColor,
        overlayColor: customColors.sliderColor.withAlpha((0.2 * 255).round()),
        valueIndicatorColor: customColors.sliderColor,
        valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary.withAlpha((0.5 * 255).round());
          }
          return Colors.grey.withAlpha((0.5 * 255).round());
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: customColors.primary,
        unselectedLabelColor: customColors.secondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: customColors.primary, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: customColors.borderColorSecondary.withAlpha((0.5 * 255).round()),
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black87,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: customColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: customColors.primary,
        circularTrackColor: customColors.cardColorPrimary,
        linearTrackColor: customColors.cardColorPrimary,
      ),
    );
  }

  /// Creates a dark theme based on CustomColors and CustomStyles
  static ThemeData darkTheme() {
    final customColors = ThemeColors.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: customColors.primary,
      scaffoldBackgroundColor: const Color(0xFF161A26),
      colorScheme: ColorScheme.dark(
        primary: customColors.primary,
        secondary: customColors.secondary,
        surface: customColors.cardColorPrimary,
        background: const Color(0xFF161A26),
        error: customColors.bearishColor,
      ),
      cardTheme: CardThemeData(
        color: customColors.cardColorPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: customColors.borderColorSecondary,
            width: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF161A26),
        foregroundColor: customColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xff222838),
        selectedItemColor: customColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: customColors.buttonColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: customColors.primary,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: customColors.primary,
          side: BorderSide(color: customColors.buttonBorderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: customColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xff222838),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.borderColorSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.borderColorSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: customColors.bearishColor),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: customColors.sliderColor,
        inactiveTrackColor:
            customColors.sliderColor.withAlpha((0.3 * 255).round()),
        thumbColor: customColors.sliderColor,
        overlayColor: customColors.sliderColor.withAlpha((0.2 * 255).round()),
        valueIndicatorColor: customColors.sliderColor,
        valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customColors.primary.withAlpha((0.5 * 255).round());
          }
          return Colors.grey.withAlpha((0.5 * 255).round());
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: customColors.primary,
        unselectedLabelColor: Colors.grey,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: customColors.primary, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.withAlpha((0.3 * 255).round()),
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xff222838),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[800],
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: customColors.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: customColors.primary,
        circularTrackColor:
            customColors.cardColorPrimary.withAlpha((0.5 * 255).round()),
        linearTrackColor:
            customColors.cardColorPrimary.withAlpha((0.5 * 255).round()),
      ),
    );
  }
}
