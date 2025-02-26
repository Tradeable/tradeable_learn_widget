import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

class ChartSimulationWidget extends StatefulWidget {
  const ChartSimulationWidget({super.key});

  @override
  State<ChartSimulationWidget> createState() => _ChartSimulationWidgetState();
}

class _ChartSimulationWidgetState extends State<ChartSimulationWidget> {
  bool isVisible = true;

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CustomPopup(
          title: "This is a Simulation!!",
          content:
              'These are simulated charts with hypothetical data, created for educational purposes only. They are not based on real market conditions and do not represent actual market trends or future performance.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return GestureDetector(
      onTap: () => _showPopup(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: colors.supportItemColor,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text("This chart is a simulation",
                style: textStyles.smallNormal.copyWith(color: Colors.white)),
            const Spacer(),
            const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            IconButton(
              onPressed: () => setState(() => isVisible = false),
              icon: const Icon(Icons.close, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
