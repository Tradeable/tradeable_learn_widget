import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

class TradeFormWidget extends StatefulWidget {
  final TradeFormModel tradeFormModel;

  const TradeFormWidget({super.key, required this.tradeFormModel});

  @override
  State<StatefulWidget> createState() => _TradeFormWidget();
}

class _TradeFormWidget extends State<TradeFormWidget> {
  late TradeFormModel model;

  @override
  void initState() {
    model = widget.tradeFormModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    String tradeStatus = "Holding";
    double? ltp = double.tryParse(model.ltp ?? "0");
    double? targetPrice = double.tryParse(model.target);
    double? stopPrice = double.tryParse(model.stopLoss);
    double? avgPrice = double.tryParse(model.avgPrice ?? "0");

    if (ltp != null && targetPrice != null && stopPrice != null) {
      if ((model.isSell && ltp <= targetPrice) ||
          (!model.isSell && ltp >= targetPrice)) {
        tradeStatus = "Target Hit";
      } else if ((model.isSell && ltp >= stopPrice) ||
          (!model.isSell && ltp <= stopPrice)) {
        tradeStatus = "Stoploss Hit";
      }
    }

    Widget arrowIndicator = Container();
    if (ltp != null && avgPrice != null) {
      double profit = model.isSell ? avgPrice - ltp : ltp - avgPrice;

      bool isProfit = model.isCallTrade ? profit > 0 : profit < 0;

      arrowIndicator = Lottie.asset(
          package: 'tradeable_learn_widget/lib',
          isProfit
              ? "assets/lottie/profit_animation.json"
              : "assets/lottie/loss_animation.json",
          height: 40,
          fit: BoxFit.fitHeight);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.borderColorSecondary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: model.isSell
                        ? colors.bearishColor
                        : colors.bullishColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: colors.borderColorSecondary)),
                child: Text(
                  model.isSell ? "Sell" : "Buy",
                  style: textStyles.smallNormal
                      .copyWith(color: colors.cardBasicBackground),
                ),
              ),
              const SizedBox(width: 10),
              Text(model.tradeType.name),
              const Spacer(),
              model.orderType == OrderType.sltg
                  ? Text("$tradeStatus ", style: textStyles.smallNormal)
                  : const Text("Executed"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(model.ticker ?? "BANKNIFTY250123CE",
                  style: textStyles.mediumNormal),
              const Spacer(),
              arrowIndicator
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(model.isNse ? "NSE" : "BSE", style: textStyles.smallNormal),
              const SizedBox(width: 8),
              Text("QTY",
                  style: textStyles.smallNormal
                      .copyWith(color: colors.textColorSecondary)),
              const SizedBox(width: 4),
              Text(model.quantity.toString(), style: textStyles.smallNormal),
              const SizedBox(width: 4),
              Text("AVG",
                  style: textStyles.smallNormal
                      .copyWith(color: colors.textColorSecondary)),
              const SizedBox(width: 4),
              Text(model.avgPrice ?? "0", style: textStyles.smallNormal),
              const Spacer(),
              const Text("LTP: "),
              const SizedBox(width: 4),
              Text(model.ltp ?? "0", style: textStyles.smallNormal),
            ],
          )
        ],
      ),
    );
  }
}
