import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/info_container_bg.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class CustomTable extends StatefulWidget {
  final TableTask tableTask;

  const CustomTable({super.key, required this.tableTask});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final Map<int, bool> _expandedMap = {};

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.tableTask.tables.tables.asMap().entries.map((entry) {
            final int tableIdx = entry.key;
            final table = entry.value;
            final bool expanded = _expandedMap[tableIdx] ?? true;
            return InfoContainerBg(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              table.tableTitle,
                              style: textStyles.mediumBold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(expanded ? Icons.remove : Icons.add),
                          onPressed: () {
                            setState(() {
                              _expandedMap[tableIdx] = !expanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(color: colors.optionChainStrokeColor),
                  if (expanded)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: colors.tableBorderColor, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  columnWidths: {
                                    for (int i = 0;
                                        i < table.columns.length;
                                        i++)
                                      i: const IntrinsicColumnWidth(),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                      children: List.generate(
                                          table.columns.length, (colIdx) {
                                        final bool useAltHeader =
                                            table.rows.length > 5;
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: useAltHeader
                                                ? colors.tableHeaderRowColorAlt
                                                : colors.tableHeaderRowColor,
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1,
                                                  color:
                                                      colors.tableBorderColor),
                                              bottom: BorderSide(
                                                  width: 2,
                                                  color:
                                                      colors.tableBorderColor),
                                              left: BorderSide(
                                                  width: 1,
                                                  color:
                                                      colors.tableBorderColor),
                                              right: BorderSide(
                                                  width: 1,
                                                  color:
                                                      colors.tableBorderColor),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                          child: Text(
                                            table.columns[colIdx],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        );
                                      }),
                                    ),
                                    ...List.generate(table.rows.length,
                                        (rowIdx) {
                                      final row = table.rows[rowIdx];
                                      final bool isAltRow =
                                          table.rows.length > 5 &&
                                              rowIdx % 2 == 1;
                                      return TableRow(
                                        children:
                                            List.generate(row.length, (colIdx) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: isAltRow
                                                  ? colors.tableAltRowColor
                                                  : Colors.white,
                                              border: Border(
                                                top: BorderSide(
                                                  width: rowIdx == 0 ? 0 : 1,
                                                  color: Colors.grey,
                                                ),
                                                bottom: BorderSide.none,
                                                left: BorderSide(
                                                  width: colIdx == 0 ? 0 : 1,
                                                  color: Colors.grey,
                                                ),
                                                right: BorderSide(
                                                  width:
                                                      colIdx == row.length - 1
                                                          ? 0
                                                          : 1,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                row[colIdx],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  if (expanded && table.tableDescription.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18, left: 14),
                      child: Text(
                        table.tableDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
