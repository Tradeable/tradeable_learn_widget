import 'package:example/main.dart';
import 'package:example/mutual_funds_widgets.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/taking_a_trade/take_a_trade_json.dart';
import 'package:tradeable_learn_widget/taking_a_trade/take_a_trade_main.dart';

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
                child: const Text("MutualFunds Widgets"))
          ],
        ),
      )),
    );
  }
}
