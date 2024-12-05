import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tradeable_learn_widget/fin_chart/fin_chart.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/horizontal_line.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/point_label.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/trend_line.dart';
import 'package:tradeable_learn_widget/fin_chart/models/fin_candle.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/x_axis_settings.dart';
import 'package:tradeable_learn_widget/fin_chart/utils.dart';

class FinChartMain extends StatefulWidget {
  const FinChartMain({super.key});

  @override
  State<FinChartMain> createState() => _FinChartMainState();
}

class _FinChartMainState extends State<FinChartMain> {
  double pos = 5;
  double value = 100;
  double hValue = 106.5;
  double hbmax = 99;
  double hbmin = 108;
  Offset startOffset = const Offset(0, 97);
  Offset endOffset = const Offset(5, 105);

  List<Layer> layers = [];

  List<FinCandle> candles = generateRandomFinCandles(50);

  @override
  Widget build(BuildContext context) {
    // for (FinCandle candle in candles) {
    //   print(candle.toString());
    // }
    return Scaffold(
      appBar: AppBar(
          // actions: [
          //   MaterialButton(
          //     onPressed: () {
          //       setState(() {
          //         yAxisPos =
          //             yAxisPos == YAxisPos.left ? YAxisPos.right : YAxisPos.left;
          //       });
          //     },
          //     child: Text("change"),
          //   )
          // ],
          ),
      body: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.7,
                  child: Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                          // color: fcbg,
                          offset: Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 0)
                    ]),
                    child: FinChart(
                      candleData: candles,
                      chartType: ChartType.candle,
                      xAxisSettings: const XAxisSettings(
                          strokeWidth: 1,
                          axisTextStyle: TextStyle(color: Colors.transparent)),
                      chartFrame: ChartFrame.fluid,
                      layers: [
                        // ChartPointer(
                        //   id: "abc",
                        //   pos: pos,
                        //   value: value,
                        //   onUpdate: (layer) {
                        //     setState(() {
                        //       pos = layer.pos;
                        //       value = layer.value;
                        //     });
                        //   },
                        // ),
                        PointLabel(
                          id: "pl",
                          containerCenterPosition: Offset(pos, value),
                          text: "I bought here",
                          isFixed: false,
                          onUpdate: (p0) {
                            setState(() {
                              pos = p0.containerCenterPosition.dx;
                              value = p0.containerCenterPosition.dy;
                            });
                          },
                        ),
                        HorizontalLine(
                          id: "line1",
                          value: hValue,
                          onUpdate: (p0) {
                            setState(() {
                              hValue = p0.value;
                            });
                          },
                        ),
                        // HorizontalLineHitBox(
                        //   id: "hitbox",
                        //   yMax: hbmax,
                        //   yMin: hbmin,
                        //   color: Colors.red.withAlpha(120),
                        //   onUpdate: (p0) {
                        //     setState(() {
                        //       hbmax = p0.yMax;
                        //       hbmin = p0.yMin;
                        //     });
                        //   },
                        // ),
                        TrendLine(
                          id: "trendLine",
                          startOffset: startOffset,
                          endOffset: endOffset,
                          color: Colors.red,
                          onUpdate: (p0) {
                            setState(() {
                              startOffset = p0.startOffset;
                              endOffset = p0.endOffset;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      // layers.add(ChartPointer(
                      //   pos: 0,
                      //   value: 0,
                      // ));
                    });
                  },
                  child: const Text("add pointer"),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
