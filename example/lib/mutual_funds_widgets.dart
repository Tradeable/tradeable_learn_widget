import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/family_plot/family_plot_widget.dart';

class MutualFundsWidgets extends StatelessWidget {
  const MutualFundsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavigationButton(text: "Family Plot", destination: FamilyPlotPage())
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class FamilyPlotPage extends StatelessWidget {
  const FamilyPlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: FamilyPlotWidget(),
    );
  }
}
