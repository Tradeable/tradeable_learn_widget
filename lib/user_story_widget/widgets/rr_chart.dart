import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeable_learn_widget/rr_widget/rr_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_form_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_simulation_widget.dart';
import 'package:tradeable_learn_widget/utils/settings_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_chart/chart.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/rr_layer/rr_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

class RRChart extends StatefulWidget {
  final RRModel model;
  final VoidCallback enableNext;
  final List<TradeFormModel>? tradeFormModel;

  const RRChart(
      {super.key,
      required this.model,
      required this.enableNext,
      this.tradeFormModel});

  @override
  State<StatefulWidget> createState() => _RRChart();
}

class _RRChart extends State<RRChart> with TickerProviderStateMixin {
  late RRModel model;
  late AnimationController controller;
  bool isAnimating = false;
  bool showLottieAnimation = false;
  bool showPnl = false;
  bool isProfitable = false;

  @override
  void initState() {
    model = widget.model;
    _loadCandlesTillAt();
    animateLayer();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RRChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      setState(() {
        model = widget.model;
        isAnimating = false;
      });
      if (widget.model.settings != null) {
        modifyUi();
      } else {
        if (widget.model.loadCandlesTillEnd ?? false) {
          loadCandlesTillEnd();
        } else {
          _loadCandlesTillAt();
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: Chart(layers: [
            AxisLayer(
                settings: AxisSettings(
                    axisColor: colors.axisColor,
                    yAxistextColor: colors.axisColor,
                    yFreq: 10)),
            CandleLayer(
                settings: ChartCandleSettings(
                    bodyThickness: 10,
                    adaptiveBodyThickness: false,
                    shadowColor: colors.axisColor),
                candles: model.uiCandles),
            model.rrLayer
              ..onUpdate = (p0, p1, p2, p3, p4) {
                setState(() {
                  model.rrLayer = RRLayer(
                      value: p0,
                      target: p1,
                      stoploss: p2,
                      startAt: p3,
                      endAt: p4);
                });
              },
          ], yMax: model.yMax, yMin: model.yMin),
        ),
        const ChartSimulationWidget(),
        if (showLottieAnimation)
          Lottie.asset(
              package: 'tradeable_learn_widget/lib',
              isProfitable
                  ? "assets/lottie/profit_animation_large.json"
                  : "assets/lottie/loss_animation_large.json",
              height: 200,
              fit: BoxFit.fitHeight),
        if (showPnl)
          Column(
              children: widget.tradeFormModel!
                  .map((model) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TradeFormWidget(tradeFormModel: model),
                      ))
                  .toList())
      ],
    );
  }

  void _loadCandlesTillAt() async {
    model.uiCandles.clear();
    for (ui.Candle candle in model.candles
        .map((e) => ui.Candle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (candle.dateTime.millisecondsSinceEpoch <= model.atTime) {
        setState(() {
          model.uiCandles.add(candle);
        });
      } else {
        break;
      }
    }
  }

  void animateLayer() {
    if (!isAnimating) {
      controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            isAnimating = false;
          }
        });

      List<Tween<double>> tweens = [
        Tween<double>(
          begin: model.rrLayer.target,
          end: model.rrLayer.target + 10,
        ),
        Tween<double>(
          begin: model.rrLayer.stoploss,
          end: model.rrLayer.stoploss - 10,
        ),
      ];

      List<Animation<double>> animations = tweens.map((tween) {
        return tween.animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
          ),
        );
      }).toList();

      for (int i = 0; i < animations.length; i++) {
        animations[i].addListener(() {
          setState(() {
            if (i == 0) {
              model.rrLayer.target = animations[i].value;
            }
            if (i == 1) {
              model.rrLayer.stoploss = animations[i].value;
            }
          });
        });
      }

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

      controller.forward();
    }
  }

  Future<void> loadCandlesTillEnd() async {
    if (model.atTime != 0) {
      for (ui.Candle candle in model.candles
          .map((e) => ui.Candle(
              candleId: e.candleNum,
              open: e.open,
              high: e.high,
              low: e.low,
              close: e.close,
              dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
              volume: e.vol.round()))
          .toList()) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (model.candles.length != model.uiCandles.length &&
            candle.dateTime.millisecondsSinceEpoch > model.atTime) {
          setState(() {
            model.uiCandles.add(candle);
          });
        }
      }
    }
  }

  Future<void> loadAllCandles({int? speed}) async {
    for (ui.Candle candle in model.candles
        .map((e) => ui.Candle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(Duration(milliseconds: speed ?? 50));
      if (model.candles.length != model.uiCandles.length) {
        setState(() {
          model.uiCandles.add(candle);
        });
      }
    }
  }

  void modifyUi() {
    SettingsModel settingsModel = widget.model.settings!;

    if (settingsModel.showPnlAnimation ?? false) {
      setState(() {
        widget.model.uiCandles.clear();
      });

      loadAllCandles(speed: settingsModel.candleSpeed).then((_) {
        setState(() {
          showLottieAnimation = true;
        });
        calculateProfitLoss();
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            if (settingsModel.showPnlInfo ?? false) {
              showPnl = true;
              showLottieAnimation = false;
            } else {
              showLottieAnimation = true;
            }
          });

          widget.enableNext();
        });
      });
    } else if (settingsModel.showPnlInfo ?? false) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showPnl = true;
        });

        widget.enableNext();
      });
    } else {
      widget.enableNext();
    }
  }

  void calculateProfitLoss() {
    if (widget.tradeFormModel != null) {
      double profit = widget.tradeFormModel!.first.isSell
          ? double.parse(widget.tradeFormModel!.first.avgPrice ?? "0") -
              double.parse(widget.tradeFormModel!.first.ltp ?? "0")
          : double.parse(widget.tradeFormModel!.first.ltp ?? "0") -
              double.parse(widget.tradeFormModel!.first.avgPrice ?? "0");

      bool isProfit =
          widget.tradeFormModel!.first.isCallTrade ? profit > 0 : profit < 0;
      setState(() {
        isProfitable = isProfit;
      });
    }
  }
}
