import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ChartInfoChips extends StatelessWidget {
  final String ticker;
  final String timeFrame;
  final String date;

  const ChartInfoChips(
      {super.key,
      required this.ticker,
      required this.timeFrame,
      required this.date});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    BoxDecoration containerDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.cardColorSecondary.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
              color: colors.borderColorSecondary.withOpacity(0.6),
              spreadRadius: 0.4)
        ],
        border: Border.all(color: colors.borderColorSecondary));

    Widget buildContainer(String title, String text) {
      return Container(
        width: 110,
        height: 60,
        decoration: containerDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
            AutoSizeText(
              text,
              maxFontSize: 16,
              minFontSize: 10,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildContainer("Script", ticker),
        buildContainer("Time Frame", timeFrame),
        buildContainer("Date", date),
      ],
    );
  }
}
