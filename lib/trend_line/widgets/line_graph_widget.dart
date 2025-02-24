import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/fin_chart.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/point_label.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/trend_line.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/x_axis_settings.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/y_axis_settings.dart';
import 'package:tradeable_learn_widget/trend_line/models/trendline_model.dart';
import 'package:tradeable_learn_widget/utils/chart_simulation_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LineGraphWidget extends StatelessWidget {
  final TrendLineModel model;
  final String question;

  const LineGraphWidget(
      {super.key, required this.model, required this.question});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Center(
      child: Column(
        children: [
          model.uiCandles.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 350,
                  child: FinChart(
                      yAxisSettings: YAxisSettings(
                          axisTextStyle: textStyles.smallNormal
                              .copyWith(color: colors.axisColor)),
                      xAxisSettings: const XAxisSettings(
                          strokeWidth: 1,
                          axisTextStyle: TextStyle(color: Colors.transparent)),
                      allowHorizontalZoom: true,
                      chartType:
                          model.isLineChart ? ChartType.line : ChartType.candle,
                      layers: [
                        ...model.pointLabelResponse.map((e) {
                          return PointLabel(
                              id: e.id,
                              containerColor: e.color,
                              containerCenterPosition: Offset(e.pos, e.value),
                              text: e.id,
                              isFixed: false,
                              onUpdate: (p0) {
                                var elementToUpdate = model.pointLabelResponse
                                    .firstWhere(
                                        (element) => element.id == e.id);
                                elementToUpdate.pos =
                                    p0.containerCenterPosition.dx;
                                elementToUpdate.value =
                                    p0.containerCenterPosition.dy;
                              });
                        }),
                        ...model.lineResponse.expand((lineData) {
                          return lineData.map((i) {
                            return TrendLine(
                                id: i.id,
                                startOffset: i.offset[0],
                                endOffset: i.offset[1],
                                color: i.color,
                                onUpdate: (p0) {
                                  var a = lineData.firstWhere(
                                      (element) => element.id == i.id);
                                  a.offset = [p0.startOffset, p0.endOffset];
                                });
                          });
                        }),
                        ...model.pointLabelCorrectResponse.map((e) {
                          return PointLabel(
                              id: e.id,
                              containerColor: e.color,
                              containerCenterPosition: Offset(e.pos, e.value),
                              text: e.id,
                              isFixed: true);
                        }),
                        ...model.lineCorrectResponse.expand((lineData) {
                          return lineData.map((i) {
                            return TrendLine(
                                id: i.id,
                                startOffset: i.offset[0],
                                endOffset: i.offset[1],
                                color: i.color,
                                width: 6);
                          });
                        }),
                      ],
                      candleData: model.uiCandles),
                )
              : Container(),
          const ChartSimulationWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
