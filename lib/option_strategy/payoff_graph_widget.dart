import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_helper.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_info_component.dart';
import 'package:tradeable_learn_widget/option_strategy/payoff_chart_widget.dart';

class PayoffGraphWidget extends StatefulWidget {
  final OptionStrategyHelper helper;
  const PayoffGraphWidget({super.key, required this.helper});

  @override
  State<PayoffGraphWidget> createState() => _PayoffGraphWidgetState();
}

class _PayoffGraphWidgetState extends State<PayoffGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Test your results by moving the slider below"),
            const SizedBox(height: 16),
            PayoffChartWidget(
              helper: widget.helper,
            ),
            const SizedBox(
              height: 16,
            ),
            const OptionStrategyInfoComponent()
          ],
        ),
      ),
    );
  }
}
