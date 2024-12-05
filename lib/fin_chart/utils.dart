import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/models/fin_candle.dart';

const fontPadding = 4;

Size getTextRenderBoxSize(String str, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: str, style: style),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();
  return Size(textPainter.width, textPainter.height);
}

Size getLargetRnderBoxSizeForList(List<String> labels, style) {
  double largestWidth = 0;
  double largetHeight = 0;
  for (String label in labels) {
    Size currentLabelSize = getTextRenderBoxSize(label, style);
    if (largestWidth < currentLabelSize.width) {
      largestWidth = currentLabelSize.width;
    }
    if (largetHeight < currentLabelSize.height) {
      largetHeight = currentLabelSize.height;
    }
  }

  return Size(largestWidth + fontPadding, largetHeight + fontPadding);
}

String generateRandomString(int length) {
  const String charset =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  Random random = Random();
  StringBuffer buffer = StringBuffer();

  for (int i = 0; i < length; i++) {
    int randomIndex = random.nextInt(charset.length);
    buffer.write(charset[randomIndex]);
  }

  return buffer.toString();
}

(double, double) findMinMaxWithPercentage(List<FinCandle> candles) {
  double lowest = candles[0].low;
  double highest = candles[0].high;

  for (FinCandle candle in candles) {
    if (candle.low < lowest) {
      lowest = candle.low;
    }
    if (candle.high > highest) {
      highest = candle.high;
    }
  }
  double range = highest - lowest;

  double lowestInt = (lowest - (range * 0.05)).floor().toDouble();
  double highestInt = (highest + (range * 0.05)).ceil().toDouble();

  return (lowestInt, highestInt);
}

List<FinCandle> generateRandomFinCandles(int numCandles) {
  final List<FinCandle> candles = [];
  final random = Random();

  for (int i = 0; i < numCandles; i++) {
    int candleId = i;
    double open = 100.0 +
        random.nextDouble() *
            10.0; // Random open price (e.g., $100.0 to $110.0)
    double high = open + random.nextDouble() * 5.0; // Random high price
    double low = open - random.nextDouble() * 5.0; // Random low price
    double close = low +
        random.nextDouble() *
            (high - low); // Random close price within the range
    DateTime dateTime = DateTime.now().subtract(Duration(days: numCandles - i));
    int volume = random.nextInt(1000);
    bool isSelected = false;
    bool selectedByModel = false;

    candles.add(FinCandle(
        candleId: candleId,
        open: open,
        high: high,
        low: low,
        close: close,
        dateTime: dateTime,
        volume: volume,
        isSelected: isSelected,
        selectedByModel: selectedByModel));
  }

  return candles;
}

double calculateAngle(Offset A, Offset B) {
  double deltaX = B.dx - A.dx;
  double deltaY = B.dy - A.dy;

  double radians = atan2(deltaY, deltaX);

  double degrees = radians * 180 / pi;

  return degrees;
}
