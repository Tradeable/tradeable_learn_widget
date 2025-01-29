import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_data_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CustomTable extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<List<String>> rows;
  final List<Color> headerGradientColors;
  final String footerLabel;
  final String footerValue;
  final Color footerValueColor;
  final RowData? highlightedRowData;

  const CustomTable({
    super.key,
    required this.title,
    required this.headers,
    required this.rows,
    required this.headerGradientColors,
    required this.footerLabel,
    required this.footerValue,
    this.footerValueColor = Colors.black,
    this.highlightedRowData,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: headerGradientColors),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(32)),
          ),
          child: Text(title),
        ),
        Container(
          color: colors.buttonColor,
          child: Table(
            border: TableBorder(
              left: BorderSide(color: colors.cardColorSecondary),
              right: BorderSide(color: colors.cardColorSecondary),
              bottom: BorderSide(color: colors.cardColorSecondary),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow(headers, context, isHeader: true),
              for (int i = 0; i < rows.length; i++)
                _buildTableRow(
                  rows[i],
                  context,
                  isHighlighted: _isHighlighted(rows[i], highlightedRowData),
                ),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(List<String> cells, BuildContext context,
      {bool isHeader = false, bool isHighlighted = false}) {
    final colors = Theme.of(context).customColors;

    return TableRow(
      decoration: isHighlighted
          ? BoxDecoration(
              border: Border.all(color: colors.borderColorPrimary),
              color: colors.buttonColor,
              boxShadow: [
                BoxShadow(
                  color: colors.borderColorPrimary.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            )
          : null,
      children: cells.map((cell) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Text(
              cell,
              maxLines: 1,
              style: TextStyle(
                color: isHeader ? Colors.black54 : Colors.black87,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                fontSize: isHeader ? 12 : 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isHighlighted(List<String> rowData, RowData? highlightedRowData) {
    if (highlightedRowData == null) return false;
    return rowData[0] == highlightedRowData.price &&
        rowData[1] == highlightedRowData.orders &&
        rowData[2] == highlightedRowData.quantity;
  }
}
