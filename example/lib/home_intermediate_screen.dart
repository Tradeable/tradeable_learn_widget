import 'package:example/main.dart';
import 'package:example/mutual_funds_widgets.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/taking_a_trade/take_a_trade_json.dart';
import 'package:tradeable_learn_widget/taking_a_trade/take_a_trade_main.dart';
import 'package:tradeable_learn_widget/option_strategy/models/option_strategy_leg.model.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_container.dart';

class HomeIntermediateScreen extends StatelessWidget {
  const HomeIntermediateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const TakeATradeMain(workflowJson: takeatradejson)));
                },
                child: const Text("Take a trade")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyHomePage()));
                },
                child: const Text("Learn Widgets")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MutualFundsWidgets()));
                },
                child: const Text("MutualFunds Widgets")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OptionStrategyContainer(
                            spotPrice: 23245,
                            spotPriceDayDelta: 17.70,
                            spotPriceDayDeltaPer: 0.07,
                            onExecute: () {},
                            legs: [
                              OptionLeg(
                                symbol: "NIFTY",
                                strike: 23250,
                                type: PositionType.buy,
                                optionType: OptionType.call,
                                expiry: DateTime.parse("2025-02-06 15:30:00"),
                                quantity: 25,
                                premium: 362,
                              ),
                              OptionLeg(
                                symbol: "NIFTY",
                                strike: 23250,
                                type: PositionType.buy,
                                optionType: OptionType.put,
                                expiry: DateTime.parse("2025-02-06 15:30:00"),
                                quantity: 25,
                                premium: 310,
                              )
                            ],
                          )));
                },
                child: const Text("Option strategy")),
          ],
        ),
      )),
    );
  }
}
