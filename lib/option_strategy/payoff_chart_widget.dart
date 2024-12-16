import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_helper.dart';

class PayoffChartWidget extends StatefulWidget {
  final OptionStrategyHelper helper;
  const PayoffChartWidget({super.key, required this.helper});

  @override
  State<PayoffChartWidget> createState() => _PayoffChartWidgetState();
}

class _PayoffChartWidgetState extends State<PayoffChartWidget> {
  final bool isShowingMainData = true;
  late ChartStats chartStats;

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: chartStats.xMin,
        maxX: chartStats.xMax,
        maxY: chartStats.yMax,
        minY: chartStats.yMin,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.red.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        // lineChartBarData1_2,
        // lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return Text(value.toStringAsFixed(0),
        style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 2000,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1,
      child: Text(value.toString(), style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1000,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.red.withOpacity(0.2), width: 1),
          left: BorderSide(color: Colors.red.withOpacity(0.2), width: 1),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
      isCurved: true,
      color: Colors.green,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: chartStats.spots);

  @override
  void initState() {
    chartStats = widget.helper.calculateStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.amber,
      height: MediaQuery.of(context).size.height * 0.5,
      child: LineChart(
        sampleData1,
        // LineChartData(
        //   minX: 0, maxX: 100, minY: 200, maxY: 3500,

        //   // read about it in the LineChartData section
        // ),
        duration: const Duration(milliseconds: 250), // Optional
        curve: Curves.linear, // Optional
      ),
    );
  }
}
