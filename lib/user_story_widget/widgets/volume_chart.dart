import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';

class VolumeBarChart extends StatelessWidget {
  final List<Candle> candles;

  const VolumeBarChart({super.key, required this.candles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
        child: BarChart(
          BarChartData(
            barGroups: candles.map((candle) {
              return BarChartGroupData(
                x: candle.candleNum,
                barRods: [
                  BarChartRodData(
                    toY: candle.vol.toDouble(),
                    color: candle.close > candle.open
                        ? const Color(0xff278829)
                        : Colors.red,
                    width: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              );
            }).toList(),
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: false),
          ),
        ),
      ),
    );
  }
}
