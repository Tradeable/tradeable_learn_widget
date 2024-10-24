import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class InvestmentDataTable extends StatelessWidget {
  final double sipInvestmentAmount;
  final double lumpsumInvestmentAmount;
  final List<double> avgReturns;
  final List<double> pnl;

  const InvestmentDataTable({
    super.key,
    required this.sipInvestmentAmount,
    required this.lumpsumInvestmentAmount,
    required this.avgReturns,
    required this.pnl,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DataTable(
        columns: [
          const DataColumn(label: Text('')),
          DataColumn(label: Text('SIP', style: textStyles.smallBold)),
          DataColumn(label: Text('Lumpsum', style: textStyles.smallBold)),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Invested Amount', style: textStyles.smallBold)),
            DataCell(
                Text('₹${sipInvestmentAmount.toStringAsFixed(0)} / Month')),
            DataCell(
                Text('₹${lumpsumInvestmentAmount.toStringAsFixed(0)}/- Once')),
          ]),
          DataRow(cells: [
            DataCell(Text('Avg Returns', style: textStyles.smallBold)),
            DataCell(Text("${avgReturns[0].toStringAsFixed(2)}%")),
            DataCell(Text("${avgReturns[1].toStringAsFixed(2)}%")),
          ]),
          DataRow(cells: [
            DataCell(Text('PnL', style: textStyles.smallBold)),
            DataCell(Text(pnl[0].toStringAsFixed(2))),
            DataCell(Text(pnl[1].toStringAsFixed(2))),
          ]),
        ],
      ),
    );
  }
}
