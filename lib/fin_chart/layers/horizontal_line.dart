import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/layer.dart';

class HorizontalLine extends Layer {
  Color color;
  double value;
  TextStyle style;
  double lineWidth;
  Function(HorizontalLine)? onUpdate;
  HorizontalLine(
      {required super.id,
      super.isSelected = false,
      this.value = 0,
      this.lineWidth = 2,
      this.style = const TextStyle(
          color: Colors.black, fontSize: 11, fontWeight: FontWeight.w500),
      this.color = Colors.blue,
      this.onUpdate});

  @override
  String? getSelectedId(double pos, double value,
      {double hError = 1, double vError = 1}) {
    if ((this.value - value).abs() < vError) {
      return id;
    } else {
      return null;
    }
  }

  @override
  void onChange(double pos, double value,
      {double hError = 1, double vError = 1}) {
    this.value = value;
    if (onUpdate != null) {
      onUpdate!(this);
    }
  }
}
