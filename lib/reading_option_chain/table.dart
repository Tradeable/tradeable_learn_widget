import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/reading_option_chain/node.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class BuildTable extends StatelessWidget {
  final Color bgColor;
  final List<Node> nodes;
  final bool isReversed;
  final int currentIndex;

  const BuildTable(
      {super.key,
      required this.bgColor,
      required this.nodes,
      required this.isReversed,
      required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Table(
        columnWidths: {
          for (int i = 0; i < nodes.length; i++)
            i: const FixedColumnWidth(45.0),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(
          color: colors.axisColor,
          borderRadius: BorderRadius.circular(10),
        ),
        children: [
          TableRow(
            children: List.generate(
              nodes.length,
              (index) => TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      nodes[isReversed ? nodes.length - 1 - index : index]
                          .title,
                      textAlign: TextAlign.center,
                      style: textStyles.smallBold.copyWith(
                        fontWeight: currentIndex ==
                                (isReversed ? nodes.length - 1 - index : index)
                            ? FontWeight.w900
                            : FontWeight.normal,
                      )),
                ),
              ),
            ),
          ),
          for (int i = 0; i < 9; i++)
            TableRow(
              children: List.generate(
                nodes.length,
                (index) => TableCell(
                  child: Container(
                    color: i < 4 && !isReversed
                        ? colors.buttonColor.withOpacity(0.5)
                        : i > 3 && isReversed
                            ? colors.buttonColor.withOpacity(0.5)
                            : bgColor,
                    padding: const EdgeInsets.all(4), // Adjust padding here
                    child: Text('', style: textStyles.smallNormal),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
