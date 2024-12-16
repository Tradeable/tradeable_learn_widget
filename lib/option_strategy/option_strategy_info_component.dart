import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/option_strategy/models/option_strategy_leg.model.dart';
import 'package:tradeable_learn_widget/option_strategy/utils/option_strategy_helper.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OptionStrategyInfoComponent extends StatelessWidget {
  final OptionStrategyHelper helper;
  final double spotPrice;
  final double spotPriceDayDelta;
  final double spotPriceDayDeltaPer;
  final Function onExecute;

  const OptionStrategyInfoComponent(
      {super.key,
      required this.helper,
      required this.spotPrice,
      required this.spotPriceDayDelta,
      required this.spotPriceDayDeltaPer,
      required this.onExecute});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RowEntryWidget(
          leftChild: Text("Profit",
              style: Theme.of(context).customTextStyles.smallNormal),
          rightChild: Text(helper.yMax.toStringAsFixed(2),
              style: Theme.of(context).customTextStyles.smallBold.copyWith(
                  color: Theme.of(context).customColors.bullishColor))),
      const SizedBox(height: 16),
      RowEntryWidget(
          leftChild: Text("Break Even",
              style: Theme.of(context).customTextStyles.smallNormal),
          rightChild: Text("6000",
              style: Theme.of(context).customTextStyles.smallNormal)),
      const SizedBox(height: 16),
      RowEntryWidget(
          leftChild: Text("Loss",
              style: Theme.of(context).customTextStyles.smallNormal),
          rightChild: Text(helper.yMax.toStringAsFixed(2),
              style: Theme.of(context).customTextStyles.smallBold.copyWith(
                  color: Theme.of(context).customColors.bearishColor))),
      const SizedBox(height: 28),
      RowEntryWidget(
          leftChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(helper.legs.first.symbol,
                  style: Theme.of(context).customTextStyles.smallBold),
              Text(
                  NumberFormat.currency(
                    locale: 'en_IN',
                    symbol: '₹',
                    decimalDigits: 2,
                  ).format(spotPrice),
                  style: Theme.of(context).customTextStyles.smallBold.copyWith(
                      color: spotPriceDayDelta > 0
                          ? Theme.of(context).customColors.bullishColor
                          : Theme.of(context).customColors.bearishColor))
            ],
          ),
          rightChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("1 day change",
                  style: Theme.of(context).customTextStyles.smallNormal),
              Text("$spotPriceDayDelta ($spotPriceDayDeltaPer%)",
                  style: Theme.of(context)
                      .customTextStyles
                      .smallNormal
                      .copyWith(
                          color: spotPriceDayDelta > 0
                              ? Theme.of(context).customColors.bullishColor
                              : Theme.of(context).customColors.bearishColor))
            ],
          )),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(
                color: Theme.of(context).customColors.borderColorPrimary,
                width: 0.5)),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, position) {
              return RowEntryWidget(
                  leftChild: RichText(
                    text: TextSpan(
                      style: Theme.of(context).customTextStyles.smallNormal,
                      children: [
                        const TextSpan(
                          text: 'Strike ',
                        ),
                        TextSpan(
                            text:
                                helper.legs[position].strike.toStringAsFixed(2),
                            style: Theme.of(context)
                                .customTextStyles
                                .smallBold // e.g., "Monday 16 December"
                            ),
                        TextSpan(
                            text:
                                " ${helper.legs[position].type == PositionType.buy ? "B" : "S"}",
                            style: Theme.of(context)
                                .customTextStyles
                                .smallBold
                                .copyWith(
                                    color: helper.legs[position].type ==
                                            PositionType.buy
                                        ? Theme.of(context)
                                            .customColors
                                            .bullishColor
                                        : Theme.of(context)
                                            .customColors
                                            .bearishColor) // e.g., "Monday 16 December"
                            ),
                      ],
                    ),
                  ),
                  rightChild: RichText(
                    text: TextSpan(
                      style: Theme.of(context).customTextStyles.smallNormal,
                      children: [
                        const TextSpan(
                          text: 'Premium ',
                        ),
                        TextSpan(
                            text: helper.legs[position].premium
                                .toStringAsFixed(2),
                            style: Theme.of(context)
                                .customTextStyles
                                .smallBold // e.g., "Monday 16 December"
                            ),
                      ],
                    ),
                  ));
            },
            separatorBuilder: (context, position) {
              return const SizedBox(height: 8);
            },
            itemCount: helper.legs.length),
      ),
      const SizedBox(
        height: 32,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1,
                      color: Theme.of(context).customColors.cardColorSecondary),
                  borderRadius: BorderRadius.circular(8.0)),
              color: Theme.of(context).customColors.cardColorSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text('Close',
                  style: Theme.of(context)
                      .customTextStyles
                      .mediumBold
                      .copyWith(color: Theme.of(context).customColors.primary)),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () {
                onExecute.call();
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: Theme.of(context).customColors.primary),
                  borderRadius: BorderRadius.circular(8.0)),
              color: Theme.of(context).customColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text('Execute',
                  style: Theme.of(context)
                      .customTextStyles
                      .mediumBold
                      .copyWith(color: Colors.white)),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 32,
      ),
    ]);
  }
}

class RowEntryWidget extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  const RowEntryWidget(
      {super.key, required this.leftChild, required this.rightChild});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [leftChild, rightChild],
    );
  }
}
