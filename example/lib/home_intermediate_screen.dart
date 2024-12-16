import 'package:example/main.dart';
import 'package:example/mutual_funds_widgets.dart';
import 'package:flutter/material.dart';
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
                            spotPrice: 24662,
                            spotPriceDayDelta: 17.70,
                            spotPriceDayDeltaPer: 0.07,
                            onExecute: () {},
                            legs: [
                              OptionLeg(
                                symbol: "NIFTY",
                                strike: 24750,
                                type: PositionType.buy,
                                optionType: OptionType.call,
                                expiry: DateTime.parse("2024-12-19 15:30:00"),
                                quantity: 25,
                                premium: 121.8,
                              ),
                              OptionLeg(
                                symbol: "NIFTY",
                                strike: 24900,
                                type: PositionType.sell,
                                optionType: OptionType.call,
                                expiry: DateTime.parse("2024-12-19 15:30:00"),
                                quantity: 25,
                                premium: 73.35,
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
