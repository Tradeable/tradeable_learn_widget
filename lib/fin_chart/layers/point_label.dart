import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/layer.dart';

class PointLabel extends Layer {
  String text;
  TextStyle style;
  Color containerColor;
  Offset containerCenterPosition;
  bool isFixed;
  Function(PointLabel)? onUpdate;
  PointLabel(
      {required super.id,
      super.isSelected = false,
      required this.containerCenterPosition,
      required this.text,
      required this.isFixed,
      this.onUpdate,
      this.containerColor = Colors.blue,
      this.style = const TextStyle(
          color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)});

  @override
  String? getSelectedId(double pos, double value,
      {double hError = 1, double vError = 1}) {
    if ((containerCenterPosition.dx - pos).abs() < hError &&
        (containerCenterPosition.dy - value).abs() < vError &&
        !isFixed) {
      return id;
    } else {
      return null;
    }
  }

  @override
  void onChange(double pos, double value,
      {double hError = 1, double vError = 1}) {
    if (!isFixed) {
      containerCenterPosition = Offset(pos, value);
    }
    if (onUpdate != null) {
      onUpdate!(this);
    }
  }
}
