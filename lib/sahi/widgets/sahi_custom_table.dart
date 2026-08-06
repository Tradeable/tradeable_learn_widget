import 'package:fin_chart/models/table_model.dart';
import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class SahiCustomTable extends StatefulWidget {
  final TableTask tableTask;

  const SahiCustomTable({
    super.key,
    required this.tableTask,
  });

  @override
  State<SahiCustomTable> createState() => SahiCustomTableState();

  factory SahiCustomTable.from({
    GlobalKey? key,
    required TableTask tableTask,
  }) {
    return SahiCustomTable(
      key: key,
      tableTask: TableTask(tables: tableTask.tables),
    );
  }
}

class SahiCustomTableState extends State<SahiCustomTable> {
  final Map<int, bool> _expandedMap = {};
  Set<int> selectedRows = {};

  @override
  void initState() {
    super.initState();
  }

  void _toggleRowSelection(int rowIdx) {
    setState(() {
      if (selectedRows.contains(rowIdx)) {
        selectedRows.remove(rowIdx);
      } else {
        selectedRows.add(rowIdx);
      }
    });
  }

  void setSelectedRows(Set<int> rows) {
    setState(() {
      selectedRows = Set<int>.from(rows);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final table = widget.tableTask.tables.tables.first;
    final bool expanded = _expandedMap[0] ?? true;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, table, textStyles, expanded),
          Padding(
            padding: const EdgeInsets.all(8),
            child: expanded
                ? _buildTableBlock(context, table, colors, textStyles)
                : const SizedBox.shrink(),
          ),
          if (table.tableDescription.isNotEmpty)
            _buildDescriptionBlock(table, textStyles),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TableModel table,
      CustomStyles textStyles, bool expanded) {
    return Padding(
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
                _expandedMap[0] = !expanded;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableBlock(BuildContext context, TableModel table,
      CustomColors colors, CustomStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: colors.optionChainStrokeColor, width: 1.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Table(
                columnWidths: {
                  for (int i = 0; i < table.columns.length; i++)
                    i: const FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder(
                  horizontalInside: BorderSide(
                      color: colors.optionChainStrokeColor, width: 1.2),
                  verticalInside: BorderSide.none,
                ),
                children: [
                  _buildTableHeaderRow(table, colors, textStyles),
                  ...List.generate(table.rows.length, (rowIdx) {
                    return _buildTableRow(table, rowIdx, colors, textStyles);
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  TableRow _buildTableHeaderRow(
      TableModel table, CustomColors colors, CustomStyles textStyles) {
    final bool useAltHeader = table.rows.length > 5;
    return TableRow(
      children: List.generate(table.columns.length, (colIdx) {
        return Container(
          decoration: BoxDecoration(
            color: useAltHeader
                ? colors.tableHeaderRowColorAlt
                : colors.tableHeaderRowColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            table.columns[colIdx],
            style: textStyles.smallBold
                .copyWith(color: colors.sahiToolbarActiveIconColor),
          ),
        );
      }),
    );
  }

  TableRow _buildTableRow(TableModel table, int rowIdx, CustomColors colors,
      CustomStyles textStyles) {
    final row = table.rows[rowIdx];
    final bool isAltRow = table.rows.length > 5 && rowIdx % 2 == 1;
    final bool isUserSelected = selectedRows.contains(rowIdx);
    return TableRow(
      children: List.generate(row.length, (colIdx) {
        return GestureDetector(
          onTap: () => _toggleRowSelection(rowIdx),
          child: Container(
            decoration: BoxDecoration(
              color: isUserSelected
                  ? colors.tableSelectedRowColor
                  : isAltRow
                      ? colors.tableAltRowColor
                      : Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                row[colIdx],
                style: textStyles.smallNormal,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDescriptionBlock(TableModel table, CustomStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 14),
      child: Text(
        table.tableDescription,
        style: textStyles.smallNormal,
      ),
    );
  }
}
