import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'investment_analysis_model.dart';

class InvestmentAnalysisMain extends StatefulWidget {
  const InvestmentAnalysisMain({super.key});

  @override
  State<InvestmentAnalysisMain> createState() => _InvestmentAnalysisMainState();
}

class _InvestmentAnalysisMainState extends State<InvestmentAnalysisMain> {
  late InvestmentAnalysisModel model;
  List<String?> droppedIcons = [];
  List<double> investedAmounts = [];
  List<double> avgReturns = [];
  List<double> pnl = [];
  bool isEvaluated = false;
  List<double> yearlySipReturns = [];
  List<double> yearlyLumpsumReturns = [];

  @override
  void initState() {
    super.initState();
    model = InvestmentAnalysisModel.fromJson({
      "question": "",
      "chartData": [100, 150, 200, 120, 180, 210, 130, 170, 190, 160],
    });
    droppedIcons = List.filled(model.chartData.length, null);
    investedAmounts = List.filled(model.chartData.length, 100)..[0] += 1200;
    avgReturns = List.filled(2, 0);
    pnl = List.filled(2, 0);
    yearlySipReturns = List.filled(model.chartData.length, 0);
    yearlyLumpsumReturns = List.filled(model.chartData.length, 0);
  }

  void evaluateReturnsAndPnl() {
    double totalSipReturns = 0;
    double totalLumpsumReturns = 0;
    double totalSipPnl = 0;
    double totalLumpsumPnl = 0;
    int sipCount = 0;
    int lumpsumCount = 0;

    setState(() {
      for (int i = 0; i < droppedIcons.length; i++) {
        if (droppedIcons[i] == 'SIP') {
          double sipReturn =
              investedAmounts[i] * 0.08 * model.chartData[i] / 100;
          yearlySipReturns[i] = sipReturn;
          totalSipReturns += sipReturn;
          totalSipPnl += investedAmounts[i] + sipReturn;
          sipCount++;
        } else if (droppedIcons[i] == 'Lumpsum') {
          double lumpsumReturn =
              investedAmounts[i] * 0.12 * model.chartData[i] / 100;
          yearlyLumpsumReturns[i] = lumpsumReturn;
          totalLumpsumReturns += lumpsumReturn;
          totalLumpsumPnl += investedAmounts[i] + lumpsumReturn;
          lumpsumCount++;
        }
      }

      avgReturns[0] = sipCount > 0 ? totalSipReturns / sipCount : 0;
      avgReturns[1] = lumpsumCount > 0 ? totalLumpsumReturns / lumpsumCount : 0;
      pnl[0] = totalSipPnl;
      pnl[1] = totalLumpsumPnl;
      isEvaluated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            _buildChart(context),
            const SizedBox(height: 40),
            _buildDraggableIcons(context),
            const SizedBox(height: 20),
            _buildCalculateButton(),
            if (isEvaluated) ...[
              _buildInvestmentDataTable(),
              _buildYearlyReturnsDataTable(),
            ],
          ],
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          child: ButtonWidget(
            color: colors.primary,
            btnContent: "Next",
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    double barWidth =
        MediaQuery.of(context).size.width / model.chartData.length * 0.6;
    final colors = Theme.of(context).customColors;

    return SizedBox(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(model.chartData.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildDragTarget(index, barWidth, colors),
              const SizedBox(height: 10),
              _buildBar(index, barWidth, colors),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDragTarget(int index, double barWidth, CustomColors colors) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 40,
          width: barWidth,
          decoration: BoxDecoration(
            color: droppedIcons[index] != null
                ? colors.selectedItemColor
                : colors.cardColorSecondary,
            shape: BoxShape.circle,
          ),
          child: droppedIcons[index] != null
              ? Icon(_getIcon(droppedIcons[index]!), color: Colors.white)
              : const SizedBox.shrink(),
        );
      },
      onAccept: (data) {
        setState(() {
          droppedIcons[index] = data;
        });
      },
    );
  }

  Widget _buildBar(int index, double barWidth, CustomColors colors) {
    return Container(
      width: barWidth,
      height: model.chartData[index].toDouble(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // gradient: LinearGradient(
          //   colors: [colors.borderColorSecondary, colors.borderColorPrimary],
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          // ),
          color: colors.axisColor.withOpacity(0.8)),
    );
  }

  Widget _buildDraggableIcons(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['SIP', 'Lumpsum'].map((icon) {
        return Draggable<String>(
          data: icon,
          feedback: Icon(_getIcon(icon), color: colors.primary, size: 40),
          childWhenDragging: Icon(_getIcon(icon),
              color: colors.borderColorSecondary, size: 40),
          child: Column(
            children: [
              Icon(_getIcon(icon), color: colors.primary, size: 40),
              Text(icon),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculateButton() {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ButtonWidget(
        color: colors.primary,
        btnContent: 'Calculate',
        onTap: evaluateReturnsAndPnl,
      ),
    );
  }

  Widget _buildInvestmentDataTable() {
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
            const DataCell(Text('100/- /Month')),
            const DataCell(Text('1200/- Once')),
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

  Widget _buildYearlyReturnsDataTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Year')),
          DataColumn(label: Text('SIP')),
          DataColumn(label: Text('Lumpsum')),
        ],
        rows: List.generate(model.chartData.length, (year) {
          return DataRow(cells: [
            DataCell(Text('${2024 - year}')),
            DataCell(Text(yearlySipReturns[year].toStringAsFixed(2))),
            DataCell(Text(yearlyLumpsumReturns[year].toStringAsFixed(2))),
          ]);
        }),
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'SIP':
        return Icons.star;
      case 'Lumpsum':
        return Icons.favorite;
      default:
        return Icons.help;
    }
  }
}
