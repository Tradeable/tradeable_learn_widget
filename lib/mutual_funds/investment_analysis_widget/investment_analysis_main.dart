import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_icon.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_returns_table.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'investment_analysis_model.dart';

class InvestmentAnalysisMain extends StatefulWidget {
  final InvestmentAnalysisModel model;

  const InvestmentAnalysisMain({super.key, required this.model});

  @override
  State<InvestmentAnalysisMain> createState() => _InvestmentAnalysisMainState();
}

class _InvestmentAnalysisMainState extends State<InvestmentAnalysisMain> {
  late InvestmentAnalysisModel model;
  List<String?> droppedIcons = [];
  List<double> investedAmounts = [];
  List<double> avgReturns = List.filled(2, 0);
  bool isEvaluated = false;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    droppedIcons = List.filled(model.chartData.length, null);
    investedAmounts =
        List.generate(model.chartData.length, (i) => i == 0 ? 1300 : 100);
  }

  void evaluateReturnsAndPnl() {
    double totalSipReturns = 0, totalLumpsumReturns = 0;
    List<double> sipInvestments = List.filled(model.chartData.length, 0);
    double lumpsumInvestment = investedAmounts[1];

    for (int i = 0; i < droppedIcons.length; i++) {
      if (droppedIcons[i] == 'SIP') {
        sipInvestments[i] += 1200;
        totalSipReturns += sipInvestments[i] * 0.08 * model.chartData[i] / 100;
      } else if (droppedIcons[i] == 'Lump Sum') {
        totalLumpsumReturns +=
            lumpsumInvestment * 0.12 * model.chartData[i] / 100;
      }
    }

    int sipYears = droppedIcons.where((icon) => icon == 'SIP').length;
    int lumpsumYears = droppedIcons.where((icon) => icon == 'Lump Sum').length;

    setState(() {
      avgReturns[0] = sipYears > 0
          ? (totalSipReturns / sipYears) * 100 / (sipYears * 1200)
          : 0;
      avgReturns[1] = lumpsumYears > 0
          ? (totalLumpsumReturns / lumpsumYears) * 100 / lumpsumInvestment
          : 0;
      isEvaluated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildChart(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.question, style: textStyles.smallBold),
                      Text(model.description, style: textStyles.mediumNormal),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                InvestmentReturnsTable(
                  avgReturns: avgReturns,
                  onIconDropped: (icon, index) {
                    setState(() {
                      droppedIcons[index] = icon; // Now you have the index here
                      evaluateReturnsAndPnl();
                    });
                  },
                ),
              ],
            ),
          ),
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

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(border: Border.all(color: colors.borderColorSecondary)),
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(model.chartData.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildDragTarget(index),
              const SizedBox(height: 10),
              _buildBar(index, barWidth),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDragTarget(int index) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return InvestmentIcon(
          width: 30,
          height: 30,
          color: _getColor(droppedIcons[index] ?? ""),
        );
      },
      onAccept: (data) {
        setState(() {
          droppedIcons[index] = data;
          evaluateReturnsAndPnl();
        });
      },
    );
  }

  Widget _buildBar(int index, double barWidth) {
    double maxDataValue = model.chartData.reduce((a, b) => a > b ? a : b);
    double barHeight = (model.chartData[index] / maxDataValue) * 200;

    return Container(
      width: barWidth,
      height: barHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).customColors.axisColor.withOpacity(0.8),
      ),
    );
  }

  Color _getColor(String icon) {
    final colors = Theme.of(context).customColors;

    return icon == 'SIP'
        ? colors.sipColor
        : icon == 'Lump Sum'
            ? colors.lumpSumColor
            : colors.cardColorSecondary;
  }
}
