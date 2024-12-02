import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_info_component.dart';

class PayoffTableWidget extends StatefulWidget {
  const PayoffTableWidget({super.key});

  @override
  State<PayoffTableWidget> createState() => _PayoffTableWidgetState();
}

class _PayoffTableWidgetState extends State<PayoffTableWidget> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trading results as per different target prices"),
          OptionStrategyInfoComponent()
        ],
      ),
    );
  }
}
