import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_icon.dart';

class InvestmentReturnsTable extends StatelessWidget {
  final List<double> avgReturns;
  final Function(String, int) onIconDropped; // Updated to include index

  const InvestmentReturnsTable({
    super.key,
    required this.avgReturns,
    required this.onIconDropped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['SIP', 'Lump Sum'].map((icon) {
        return Container(
          width: 140,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.cardColorSecondary, width: 2),
          ),
          child: Column(
            children: [
              _buildDraggableIcon(icon, context),
              const SizedBox(height: 5),
              Text(icon, style: textStyles.smallBold),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: icon == "SIP" ? "100 /" : "1200 ",
                      style: textStyles.mediumNormal,
                    ),
                    TextSpan(
                      text: icon == "SIP" ? "MONTH" : "ONCE",
                      style: textStyles.smallBold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildAvgReturnRow(icon, context),
              const SizedBox(height: 10),
              _buildAvgReturnBar(icon, context),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDraggableIcon(String icon, BuildContext context) {
    return Draggable<String>(
      data: icon,
      feedback: InvestmentIcon(
          height: 40, width: 40, color: _getColor(icon, context)),
      childWhenDragging: InvestmentIcon(
          height: 40,
          width: 40,
          color: Theme.of(context).customColors.borderColorSecondary),
      child: InvestmentIcon(
          height: 70, width: 60, color: _getColor(icon, context)),
    );
  }

  Widget _buildAvgReturnRow(String icon, BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Row(
      children: [
        const Text("Avg.\nReturn"),
        const Spacer(),
        Text(
          icon == "SIP"
              ? "${avgReturns[0].toStringAsFixed(2)}%"
              : "${avgReturns[1].toStringAsFixed(2)}%",
          style: textStyles.smallBold,
        ),
      ],
    );
  }

  Widget _buildAvgReturnBar(String icon, BuildContext context) {
    double percentage = icon == "SIP" ? avgReturns[0] : avgReturns[1];
    Color barColor = _getColor(icon, context);

    return Column(
      children: [
        Divider(height: 1, color: Theme.of(context).customColors.axisColor),
        Container(
          width: 20,
          height: 100,
          alignment: Alignment.topCenter,
          child: Container(
            height: percentage.abs() > 100 ? 100 : percentage.abs(),
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColor(String icon, BuildContext context) {
    final colors = Theme.of(context).customColors;

    return icon == 'SIP'
        ? colors.sipColor
        : icon == 'Lump Sum'
            ? colors.lumpSumColor
            : colors.cardColorSecondary;
  }
}
