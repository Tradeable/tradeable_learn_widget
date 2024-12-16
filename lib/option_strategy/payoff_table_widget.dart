import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/option_strategy/utils/option_strategy_helper.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_info_component.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class PayoffTableWidget extends StatefulWidget {
  final OptionStrategyHelper helper;
  final double spotPrice;
  final double spotPriceDayDelta;
  final double spotPriceDayDeltaPer;
  final OptionStrategyInfoComponent optionStrategyInfoComponent;
  const PayoffTableWidget(
      {super.key,
      required this.helper,
      required this.spotPrice,
      required this.spotPriceDayDelta,
      required this.spotPriceDayDeltaPer,
      required this.optionStrategyInfoComponent});

  @override
  State<PayoffTableWidget> createState() => _PayoffTableWidgetState();
}

class _PayoffTableWidgetState extends State<PayoffTableWidget> {
  late List<FlSpot> theoroticalPnL;
  @override
  void initState() {
    theoroticalPnL =
        widget.helper.calculateTheoroticalFlSpots(spotPrice: widget.spotPrice);
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
            Text(
              "Trading results as per different target prices",
              style: Theme.of(context).customTextStyles.smallNormal,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.separated(
                  shrinkWrap: true,
                  //physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, pos) {
                    if (pos == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Target",
                                  style: Theme.of(context)
                                      .customTextStyles
                                      .smallBold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .customTextStyles
                                        .smallNormal,
                                    children: [
                                      TextSpan(
                                        text: 'On Target Date',
                                        style: Theme.of(context)
                                            .customTextStyles
                                            .smallBold,
                                      ),
                                      const TextSpan(
                                          text: '\n'), // Add a line break
                                      TextSpan(
                                        text: DateFormat('EE d MMM').format(widget
                                            .helper
                                            .legs
                                            .first
                                            .expiry), // e.g., "Monday 16 December"
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: RichText(
                                    text: TextSpan(
                                  style: Theme.of(context)
                                      .customTextStyles
                                      .smallNormal,
                                  children: [
                                    TextSpan(
                                      text: 'On Expiry',
                                      style: Theme.of(context)
                                          .customTextStyles
                                          .smallBold,
                                    ),
                                    const TextSpan(
                                        text: '\n'), // Add a line break
                                    TextSpan(
                                      text: DateFormat('EE d MMM').format(DateTime
                                          .now()), // e.g., "Monday 16 December"
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return MaterialButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          // const WidgetSpan(
                                          //     alignment:
                                          //         PlaceholderAlignment.middle,
                                          //     child: Icon(
                                          //       Icons.edit_rounded,
                                          //       color: Colors.pink,
                                          //       size: 14,
                                          //     )),
                                          const TextSpan(
                                            text:
                                                "  ", // e.g., "Monday 16 December"
                                          ),
                                          TextSpan(
                                            text: widget.helper.xValues[pos - 1]
                                                .toString(), // e.g., "Monday 16 December"
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    widget.helper.expirationPnLvalues[pos - 1].y
                                        .toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .customTextStyles
                                        .smallNormal
                                        .copyWith(
                                          color: widget
                                                      .helper
                                                      .expirationPnLvalues[
                                                          pos - 1]
                                                      .y >
                                                  0
                                              ? Theme.of(context)
                                                  .customColors
                                                  .bullishColor
                                              : Theme.of(context)
                                                  .customColors
                                                  .bearishColor,
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                      theoroticalPnL[pos - 1]
                                          .y
                                          .toStringAsFixed(2),
                                      style: Theme.of(context)
                                          .customTextStyles
                                          .smallNormal
                                          .copyWith(
                                            color: theoroticalPnL[pos - 1].y > 0
                                                ? Theme.of(context)
                                                    .customColors
                                                    .bullishColor
                                                : Theme.of(context)
                                                    .customColors
                                                    .bearishColor,
                                          )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (context, pos) {
                    return Divider(
                      height: 0,
                      thickness: 1,
                      color:
                          Theme.of(context).customColors.borderColorSecondary,
                    );
                  },
                  itemCount: widget.helper.xValues.length + 1),
            ),
            const SizedBox(
              height: 32,
            ),
            widget.optionStrategyInfoComponent
          ],
        ),
      ),
    );
  }
}
