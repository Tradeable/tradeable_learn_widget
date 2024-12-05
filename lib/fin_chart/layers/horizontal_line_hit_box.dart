import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/layer.dart';

class HorizontalLineHitBox extends Layer {
  Color color;
  double yMax;
  double yMin;
  Function(HorizontalLineHitBox)? onUpdate;

  HorizontalLineHitBox(
      {required super.id,
      super.isSelected = false,
      this.color = Colors.green,
      required this.yMax,
      required this.yMin,
      this.onUpdate});

  @override
  String? getSelectedId(double pos, double value,
      {double hError = 1, double vError = 1}) {
    if (value < yMax + vError && value > yMin - vError) {
      return id;
    } else {
      return null;
    }
  }

  @override
  void onChange(double pos, double value,
      {double hError = 1, double vError = 1}) {
    double dist = yMax - yMin;
    if (value > (yMin + dist * 0.66)) {
      yMax = value;
    } else if (value < (yMin + dist * 0.33)) {
      yMin = value;
    } else {
      yMax = value + dist / 2;
      yMin = value - dist / 2;
    }
    if (onUpdate != null) {
      onUpdate!(this);
    }
  }
}
