import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/option_strategy/utils/option_strategy_helper.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_info_component.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class PayoffGraphWidget extends StatefulWidget {
  final OptionStrategyHelper helper;
  final double spotPrice;
  final double spotPriceDayDelta;
  final double spotPriceDayDeltaPer;
  final OptionStrategyInfoComponent optionStrategyInfoComponent;
  const PayoffGraphWidget(
      {super.key,
      required this.helper,
      required this.spotPrice,
      required this.spotPriceDayDelta,
      required this.spotPriceDayDeltaPer,
      required this.optionStrategyInfoComponent});

  @override
  State<PayoffGraphWidget> createState() => _PayoffGraphWidgetState();
}

class _PayoffGraphWidgetState extends State<PayoffGraphWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Test your results by moving the slider below",
                style: Theme.of(context).customTextStyles.smallNormal),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: LineChart(
                LineChartData(
                    minY: widget.helper.yMin - 1000,
                    maxY: widget.helper.yMax + 1000,
                    clipData: const FlClipData.all(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        maxIncluded: false,
                        minIncluded: false,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toStringAsFixed(2),
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center);
                        },
                      )),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        maxIncluded: false,
                        minIncluded: false,
                        getTitlesWidget: (value, meta) {
                          return Text(meta.formattedValue,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.justify);
                        },
                      )),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Container();
                        },
                      )),
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Container();
                        },
                      )),
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: const Border(
                            bottom: BorderSide(width: 1, color: Colors.grey),
                            left: BorderSide(width: 1, color: Colors.grey))),
                    gridData: const FlGridData(
                        drawHorizontalLine: false, drawVerticalLine: true),
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((spotIndex) {
                          return TouchedSpotIndicatorData(
                            const FlLine(color: Colors.blue, strokeWidth: 2),
                            FlDotData(
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: Colors.blue,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((barSpot) {
                            final flSpot = barSpot;
                            if (barSpot.barIndex == 0) {
                              return LineTooltipItem(
                                flSpot.y > 0
                                    ? "Project profit : "
                                    : "Projected loss : ",
                                Theme.of(context)
                                    .customTextStyles
                                    .smallNormal
                                    .copyWith(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: flSpot.y.toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .customTextStyles
                                        .smallNormal
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              );
                            }
                          }).toList();
                        },
                        getTooltipColor: (touchedSpot) {
                          return touchedSpot.y > 0
                              ? Theme.of(context)
                                  .customColors
                                  .bullishColor
                                  .withOpacity(0.5)
                              : Theme.of(context)
                                  .customColors
                                  .bearishColor
                                  .withOpacity(0.5);
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                          barWidth: 1,
                          color: Colors.black,
                          dotData: const FlDotData(show: false),
                          spots: widget.helper.expirationPnLvalues,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.green.withOpacity(0.2),
                            cutOffY: 0,
                            applyCutOffY: true,
                          ),
                          aboveBarData: BarAreaData(
                              show: true,
                              color: Colors.red.withOpacity(0.2),
                              cutOffY: 0,
                              applyCutOffY: true)),
                      LineChartBarData(
                        barWidth: 1,
                        color: Colors.blue,
                        dotData: const FlDotData(show: false),
                        spots: widget.helper.calculateTheoroticalFlSpots(
                            spotPrice: widget.spotPrice),
                      ),
                    ]),
                duration: const Duration(milliseconds: 250), // Optional
                curve: Curves.linear, // Optional
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            widget.optionStrategyInfoComponent
          ],
        ),
      ),
    );
  }
}
