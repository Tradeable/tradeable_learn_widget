import 'package:example/main.dart';
import 'package:example/mutual_funds_widgets.dart';
import 'package:flutter/material.dart';
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
                      builder: (context) => const OptionStrategyContainer()));
                },
                child: const Text("Option strategy")),
          ],
        ),
      )),
    );
  }
}
