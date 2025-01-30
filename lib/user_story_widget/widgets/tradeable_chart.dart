import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_chart/chart.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/line_layer/line_layer.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;

class TradeableChart extends StatefulWidget {
  final HorizontalLineModel model;

  const TradeableChart({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _TradeableChart();
}

class _TradeableChart extends State<TradeableChart>
    with TickerProviderStateMixin {
  bool isAnimating = false;

  @override
  void didUpdateWidget(covariant TradeableChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      setState(() {
        isAnimating = false;
      });
      _loadAllCandles();
    }
  }

  @override
  void initState() {
    _loadAllCandles();
    animateLine();
    super.initState();
  }

  void animateLine() {
    if (!isAnimating) {
      for (int i = 0; i < widget.model.userResponse.length; i++) {
        final value = widget.model.userResponse[i].value;
        final endValue = value + 15;

        final controller = AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: this,
        );

        final animation = Tween<double>(
          begin: value,
          end: endValue,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
          ),
        );

        controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controller.reverse();
          }
        });

        controller.addListener(() {
          setState(() {
            widget.model.userResponse[i].value = animation.value;
          });
        });

        controller.forward();
      }

      setState(() {
        isAnimating = true;
      });
    }
  }

  void _loadAllCandles() async {
    for (int i = 0; i < widget.model.responseRange.length; i++) {
      widget.model.userResponse.add(LineUserResponse(
          i.toString(),
          widget.model.yMax +
              i * 2 -
              (widget.model.yMax - widget.model.yMin) / 2));
    }
    for (ui.Candle candle in widget.model.candles
        .map((e) => ui.Candle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(
          Duration(milliseconds: widget.model.candleSpeed ?? 50));
      setState(() {
        widget.model.uiCandles.add(candle);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Chart(layers: [
      AxisLayer(
          settings: AxisSettings(
              axisColor: colors.axisColor,
              yAxistextColor: colors.axisColor,
              yFreq: 10)),
      ...widget.model.userResponse.map(
        (e) {
          return LineLayer(
            id: e.id,
            value: e.value,
            color: const Color(0xffF9B0CC),
            textColor: colors.axisColor,
            onUpdate: (p0) {
              setState(() {
                widget.model.userResponse
                    .firstWhere((element) => element.id == e.id)
                    .value = p0;
              });
            },
            lineColor: colors.borderColorPrimary,
          );
        },
      ),
      CandleLayer(
          settings: ChartCandleSettings(
              bodyThickness: 8,
              adaptiveBodyThickness: true,
              shadowColor: colors.axisColor),
          candles: widget.model.uiCandles),
      ...widget.model.correctResponseLayer
    ], yMax: widget.model.yMax, yMin: widget.model.yMin);
  }
}
