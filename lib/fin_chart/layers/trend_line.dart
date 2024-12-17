import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/layer.dart';
import 'package:tradeable_learn_widget/fin_chart/utils.dart';

class TrendLine extends Layer {
  Offset startOffset;
  Offset endOffset;
  Color color;
  double width;
  double angle;
  Function(TrendLine)? onUpdate;
  TrendLine(
      {required super.id,
      super.isSelected = false,
      required this.startOffset,
      required this.endOffset,
      this.width = 2,
      this.angle = 0,
      this.color = Colors.black,
      this.onUpdate});

  @override
  String? getSelectedId(double pos, double value,
      {double hError = 1, double vError = 1}) {
    if (((startOffset.dx - pos).abs() < hError &&
            (startOffset.dy - value).abs() < vError) ||
        ((endOffset.dx - pos).abs() < hError &&
            (endOffset.dy - value).abs() < vError)) {
      return id;
    } else {
      return null;
    }
  }

  @override
  void onChange(double pos, double value,
      {double hError = 1, double vError = 1}) {
    if ((startOffset.dx - pos).abs() < hError &&
        (startOffset.dy - value).abs() < vError) {
      startOffset = Offset(pos, value);
    } else if ((endOffset.dx - pos).abs() < hError &&
        (endOffset.dy - value).abs() < vError) {
      endOffset = Offset(pos, value);
    }
    angle = calculateAngle(startOffset, endOffset);
    if (onUpdate != null) {
      onUpdate!(this);
    }
  }
}
