import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/app_theme.dart';

typedef TokenRefreshCallback = Future<String> Function();
typedef TokenExpirationCallback = void Function();

class TLW {
  ThemeData? themeData;
  static final TLW _instance = TLW._internal();

  factory TLW() => _instance;

  TLW._internal();

  void initialize({ThemeData? themeData}) {
    this.themeData = themeData ?? AppTheme.lightTheme();
  }
}
