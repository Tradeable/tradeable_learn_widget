import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BuySellV1 extends StatefulWidget {
  const BuySellV1({super.key});

  @override
  State<BuySellV1> createState() => _BuySellV1State();
}

class _BuySellV1State extends State<BuySellV1> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              height: constraints.maxHeight * 0.6,
              child: LineChart(LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.white, width: 4),
                      left: BorderSide(color: Colors.transparent),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  lineTouchData: const LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(),
                  ),
                  lineBarsData: [
                    LineChartBarData(spots: const [
                      FlSpot(0, 23),
                      FlSpot(1, 37),
                      FlSpot(2, 38),
                      FlSpot(3, 43),
                      FlSpot(4, 36),
                      FlSpot(5, 45),
                      FlSpot(6, 49),
                      FlSpot(7, 54),
                      FlSpot(8, 57),
                      FlSpot(9, 59),
                      FlSpot(10, 61),
                      FlSpot(11, 63),
                      FlSpot(12, 67),
                      FlSpot(13, 81),
                      FlSpot(14, 83),
                      FlSpot(15, 87),
                      FlSpot(16, 89),
                      FlSpot(17, 79),
                      FlSpot(18, 75),
                      FlSpot(19, 77),
                    ])
                  ]))),
          renderInstruction()
        ],
      );
    });
  }

  Widget renderInstruction() {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: Text(
        "Select the correct point at which you should sell to maximise profit",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
