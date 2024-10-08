import 'dart:ui';

class AxisSettings {
  final Color axisColor;
  final Color yAxistextColor;
  final int yFreq;
  final List<String>? xAxisValues;

  AxisSettings(
      {required this.axisColor,
      required this.yAxistextColor,
      required this.yFreq,
      this.xAxisValues});
}
