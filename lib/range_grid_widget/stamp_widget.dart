import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/range_grid_widget/trapeziod_stamp_painter.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class StampContainer extends StatelessWidget {
  final int index;
  final String value;
  final bool isDragging;

  const StampContainer({
    super.key,
    required this.index,
    required this.value,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 60,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.primaries[index],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                height: 20,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.primaries[index].shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        Container(
            height: 20,
            width: 25,
            decoration: BoxDecoration(color: colors.axisColor)),
        CustomPaint(
          size: const Size(100, 40),
          painter: TrapezoidPainter(
              value: value,
              bgColor: colors.axisColor,
              textColor: colors.buttonColor),
        ),
        Container(
          height: 12,
          width: 100,
          color: const Color.fromRGBO(73, 57, 57, 1),
        )
      ],
    );
  }
}
