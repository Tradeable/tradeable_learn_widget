import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class JourneyToolbarItem extends StatelessWidget {
  final JourneyItem item;
  final CustomColors colors;
  final int index;

  const JourneyToolbarItem({
    super.key,
    required this.item,
    required this.colors,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = item.active
        ? colors.sahiToolbarActiveIconColor
        : colors.sahiToolbarIconColor;

    final bgColor =
        item.active ? colors.sahiToolbarActiveBg : Colors.transparent;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: item.completed
              ? colors.sahiCompletedJourneyBg.withAlpha((0.15 * 255).round())
              : item.active
                  ? iconColor
                  : null,
          shape: BoxShape.circle,
          border: item.completed
              ? null
              : Border.all(
                  color: colors.sahiToolbarIconColor
                      .withAlpha((0.4 * 255).round())),
        ),
        padding: const EdgeInsets.all(4),
        child: Center(
          child: item.completed
              ? Icon(
                  Icons.check,
                  size: 18,
                  color: colors.sahiCompletedJourneyBg,
                )
              : Text(
                  index.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: item.active
                        ? Colors.white
                        : iconColor.withAlpha((0.6 * 255).round()),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ),
    );
  }
}
