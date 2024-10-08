import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class BricksWidget extends StatelessWidget {
  final List<LadderCell> values;
  final Widget Function(LadderCell) buildDragTarget;
  final BoxConstraints constraints;

  const BricksWidget({
    super.key,
    required this.values,
    required this.buildDragTarget,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    double brickHeight = constraints.maxHeight / (values.length * 2 + 1);

    List<Widget> rows = [];

    for (int i = 0; i < values.length; i++) {
      double brickWidth1 = constraints.maxWidth * 0.4;
      double brickWidth2 = constraints.maxWidth * 1;

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BricksContainer(
              height: brickHeight,
              width: (i % 2 == 0) ? brickWidth1 : brickWidth2 - 30,
              borderColor: colors.borderColorPrimary.withOpacity(0.4),
              containerColor: colors.cardColorPrimary,
              removeLeftBorder: true,
            ),
            SizedBox(
              width: (i % 2 == 0) ? brickWidth2 : brickWidth1 + 30,
              child: ValueWidget(
                value: values[i],
                buildDragTarget: buildDragTarget,
                height: brickHeight,
                width: (i % 2 == 0) ? brickWidth2 : brickWidth1,
              ),
            ),
          ],
        ),
      );

      if (i < values.length - 1) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              2,
              (index) {
                double width = index == 0 ? brickWidth2 : brickWidth1;
                return BricksContainer(
                  height: brickHeight,
                  width: width,
                  borderColor: colors.borderColorPrimary,
                  containerColor: colors.cardColorPrimary,
                  removeLeftBorder: index == 0,
                  removeTopBorder: true,
                );
              },
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brick Wall\n(options)",
          style: textStyles.smallBold.copyWith(fontSize: 12),
        ),
        ...rows,
      ],
    );
  }
}

class BricksContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color borderColor;
  final Color containerColor;
  final bool removeLeftBorder;
  final bool removeTopBorder;

  const BricksContainer({
    super.key,
    required this.height,
    required this.width,
    required this.borderColor,
    required this.containerColor,
    this.removeLeftBorder = false,
    this.removeTopBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(4),
        border: Border(
          top: removeTopBorder
              ? BorderSide.none
              : BorderSide(color: borderColor.withOpacity(0.4), width: 2),
          right: BorderSide(color: borderColor.withOpacity(0.4), width: 2),
          bottom: BorderSide(color: borderColor.withOpacity(0.4), width: 2),
          left: removeLeftBorder
              ? BorderSide.none
              : BorderSide(color: borderColor.withOpacity(0.4), width: 2),
        ),
      ),
    );
  }
}

class ValueWidget extends StatelessWidget {
  final LadderCell value;
  final Widget Function(LadderCell) buildDragTarget;
  final double height;
  final double width;

  const ValueWidget({
    super.key,
    required this.value,
    required this.buildDragTarget,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return value.model.isQuestion
        ? buildDragTarget(value)
        : Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colors.cardColorPrimary,
              border: Border(
                top: BorderSide(
                    color: colors.borderColorPrimary.withOpacity(0.4),
                    width: 2),
                right: BorderSide(
                    color: colors.borderColorPrimary.withOpacity(0.4),
                    width: 3),
                bottom: BorderSide(
                    color: colors.borderColorPrimary.withOpacity(0.4),
                    width: 2),
                left: BorderSide(
                    color: colors.borderColorPrimary.withOpacity(0.4),
                    width: 2),
              ),
            ),
            child: Center(
              child: Text(
                value.model.value,
                textAlign: TextAlign.center,
                style: textStyles.smallBold,
              ),
            ),
          );
  }
}
