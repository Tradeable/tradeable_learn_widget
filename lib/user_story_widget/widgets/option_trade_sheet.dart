import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tlw.dart';

class OptionTradeSheet extends StatelessWidget {
  final String limitPrice;
  final String quantity;

  const OptionTradeSheet(
      {super.key, required this.limitPrice, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final colors = TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles = TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderColorSecondary)),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text("BANKNIFTY2500123CE", style: textStyles.mediumBold),
          const SizedBox(height: 20),
          _buildRow("Market Price: ", limitPrice, context),
          const SizedBox(height: 6),
          _buildRow("Quantity: ", quantity, context),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                "Status: ",
                style: textStyles.smallNormal
                    .copyWith(color: colors.textColorSecondary),
              ),
              const SizedBox(width: 10),
              Text(
                "Executed",
                style:
                    textStyles.mediumBold.copyWith(color: colors.bullishColor),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, BuildContext context) {
    final colors = TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles = TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Row(
      children: [
        Text(
          label,
          style:
              textStyles.smallNormal.copyWith(color: colors.textColorSecondary),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: textStyles.smallNormal
              .copyWith(color: colors.axisColor, fontSize: 16),
        ),
      ],
    );
  }
}
