import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class TradeInfo extends StatelessWidget {
  final String title;
  final String limitPrice;
  final String quantity;
  final String status;

  const TradeInfo(
      {super.key,
      required this.title,
      required this.limitPrice,
      required this.quantity,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyles.mediumBold),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Limit Price:",
                  style: textStyles.smallNormal
                      .copyWith(color: colors.axisColor.withOpacity(0.8))),
              const SizedBox(width: 14),
              Text(limitPrice, style: textStyles.smallNormal),
              const Spacer(),
              Text("Status",
                  style: textStyles.smallNormal
                      .copyWith(color: colors.axisColor.withOpacity(0.8)))
            ],
          ),
          Row(
            children: [
              Text("Quantity:",
                  style: textStyles.smallNormal
                      .copyWith(color: colors.axisColor.withOpacity(0.8))),
              const SizedBox(width: 14),
              Text(quantity, style: textStyles.smallNormal),
              const Spacer(),
              Text(status,
                  style: textStyles.mediumNormal.copyWith(
                      color: status == 'Executed'
                          ? colors.bullishColor
                          : Colors.lightBlue))
            ],
          )
        ],
      ),
    );
  }
}
