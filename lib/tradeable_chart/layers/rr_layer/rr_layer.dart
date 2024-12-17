import 'package:flutter/material.dart';

import '../chart_layer.dart';

class RRLayer extends ChartLayer {
  double value;
  double target;
  double stoploss;
  double startAt;
  double endAt;
  String updatingValue = "";
  Function(double, double, double, double, double)? onUpdate;

  RRLayer(
      {required this.value,
      required this.target,
      required this.stoploss,
      required this.startAt,
      required this.endAt,
      this.onUpdate});

  static draw(
      {required Canvas canvas,
      required Size size,
      required RRLayer layer,
      required Offset origin,
      required Offset originOffset,
      required double xh,
      required double yh,
      required double yw,
      required double h,
      required double vMax,
      required double vMin}) {
    TextPainter targetPainter = TextPainter(
      text: TextSpan(
        text: "Target : ${layer.target.toStringAsFixed(2)}",
        style: const TextStyle(color: Colors.white, height: 1.05),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    TextPainter stoplossPainter = TextPainter(
      text: TextSpan(
        text: "Stop-loss : ${layer.stoploss.toStringAsFixed(2)}",
        style: const TextStyle(color: Colors.white, height: 1.05),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    TextPainter rrPainter = TextPainter(
      text: TextSpan(
        text:
            "RR : ${((layer.target - layer.value) / (layer.value - layer.stoploss)).abs().toStringAsFixed(2)}",
        style: const TextStyle(color: Colors.white, height: 1.05),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.drawRRect(
        RRect.fromLTRBR(
            ChartLayer.cocaX(layer.startAt, yw, originOffset),
            ChartLayer.cocaY(
                layer.target, h, xh, yh, vMax, vMin, originOffset, origin),
            ChartLayer.cocaX(layer.endAt, yw, originOffset), //layer.endAt,
            ChartLayer.cocaY(
                layer.value, h, xh, yh, vMax, vMin, originOffset, origin),
            const Radius.circular(0)),
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(100, 76, 175, 79));

    canvas.drawRRect(
        RRect.fromLTRBR(
            ChartLayer.cocaX(layer.startAt, yw, originOffset), //layer.startAt,
            ChartLayer.cocaY(
                layer.stoploss, h, xh, yh, vMax, vMin, originOffset, origin),
            ChartLayer.cocaX(layer.endAt, yw, originOffset), //layer.endAt,
            ChartLayer.cocaY(
                layer.value, h, xh, yh, vMax, vMin, originOffset, origin),
            const Radius.circular(0)),
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(100, 244, 67, 54));

    double midPoint = ChartLayer.cocaX(layer.startAt, yw, originOffset) +
        (ChartLayer.cocaX(layer.endAt, yw, originOffset) -
                ChartLayer.cocaX(layer.startAt, yw, originOffset)) /
            2;

    canvas.drawRRect(
        RRect.fromLTRBR(
            midPoint - targetPainter.width / 2 - 4, //layer.startAt,
            ChartLayer.cocaY(
                    layer.target, h, xh, yh, vMax, vMin, originOffset, origin) -
                targetPainter.height / 2,
            midPoint + targetPainter.width / 2 + 4, //layer.endAt,
            ChartLayer.cocaY(
                    layer.target, h, xh, yh, vMax, vMin, originOffset, origin) +
                targetPainter.height / 2,
            const Radius.circular(0)),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.black);

    canvas.drawRRect(
        RRect.fromLTRBR(
            midPoint - stoplossPainter.width / 2 - 4, //layer.startAt,
            ChartLayer.cocaY(layer.stoploss, h, xh, yh, vMax, vMin,
                    originOffset, origin) -
                targetPainter.height / 2,
            midPoint + stoplossPainter.width / 2 + 4, //layer.endAt,
            ChartLayer.cocaY(layer.stoploss, h, xh, yh, vMax, vMin,
                    originOffset, origin) +
                stoplossPainter.height / 2,
            const Radius.circular(0)),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.black);

    canvas.drawRRect(
        RRect.fromLTRBR(
            midPoint - rrPainter.width / 2 - 4, //layer.startAt,
            ChartLayer.cocaY(
                    layer.value, h, xh, yh, vMax, vMin, originOffset, origin) -
                rrPainter.height / 2,
            midPoint + rrPainter.width / 2 + 4, //layer.endAt,
            ChartLayer.cocaY(
                    layer.value, h, xh, yh, vMax, vMin, originOffset, origin) +
                rrPainter.height / 2,
            const Radius.circular(0)),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.black);

    targetPainter.paint(
        canvas,
        Offset(
            midPoint - targetPainter.width / 2, //-4 is random padding const
            ChartLayer.cocaY(
                    layer.target, h, xh, yh, vMax, vMin, originOffset, origin) -
                targetPainter.height / 2));

    stoplossPainter.paint(
        canvas,
        Offset(
            midPoint - stoplossPainter.width / 2, //-4 is random padding const
            ChartLayer.cocaY(layer.stoploss, h, xh, yh, vMax, vMin,
                    originOffset, origin) -
                stoplossPainter.height / 2));

    rrPainter.paint(
        canvas,
        Offset(
            midPoint - rrPainter.width / 2, //-4 is random padding const
            ChartLayer.cocaY(
                    layer.value, h, xh, yh, vMax, vMin, originOffset, origin) -
                rrPainter.height / 2));
  }
}
