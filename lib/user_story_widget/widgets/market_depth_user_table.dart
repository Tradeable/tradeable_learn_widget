import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/table_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_table.dart';

class MarketDepthTableWidget extends StatelessWidget {
  final String title;
  final String tableAlignment;
  final List<TableData> tableData;
  final RowData? highlightedRowData;

  const MarketDepthTableWidget({
    super.key,
    required this.title,
    required this.tableAlignment,
    required this.tableData,
    this.highlightedRowData,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> tables = tableData.map((tableEntry) {
      final headers = ['Bid', 'Orders', 'Qty'];

      final rows = tableEntry.data
          .map((row) => [
                row.price,
                row.orders,
                row.quantity,
              ])
          .toList();

      return Padding(
        padding: const EdgeInsets.all(12),
        child: CustomTable(
          title: tableEntry.title,
          headers: headers,
          rows: rows,
          headerGradientColors:
              tableEntry.tableColors.map((e) => Color(int.parse(e))).toList(),
          footerLabel: 'Total Orders',
          footerValue: tableEntry.totalValue,
          footerValueColor: Colors.black,
          highlightedRowData: highlightedRowData,
        ),
      );
    }).toList();

    return tableAlignment == 'horizontal'
        ? Row(
            children: tables.map((table) => Expanded(child: table)).toList(),
          )
        : Column(
            children: tables.map((table) => table).toList(),
          );
  }
}
