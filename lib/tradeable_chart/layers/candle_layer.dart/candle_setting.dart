import 'package:flutter/material.dart';

class ChartCandleSettings {
  double bodyThickness;
  final bool adaptiveBodyThickness;
  final double shadowThickness;
  final Color shadowColor;
  final double radius;

  ChartCandleSettings(
      {this.bodyThickness = 10.0,
      this.adaptiveBodyThickness = true,
      this.shadowThickness = 1.0,
      this.shadowColor = Colors.white,
      this.radius = 0.0});
}
