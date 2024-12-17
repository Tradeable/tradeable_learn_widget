import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/savings_amount_widget.dart';
import 'package:tradeable_learn_widget/mutual_funds/mf_calculator_widget/mf_calculator_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MfCalculatorMain extends StatefulWidget {
  final MfCalculatorModel model;

  const MfCalculatorMain({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _MfCalculatorMain();
}

class _MfCalculatorMain extends State<MfCalculatorMain> {
  late MfCalculatorModel model;
  double savingsAmount = 0;
  DateTime? startDate;
  DateTime? endDate;
  bool showChart = false;
  List<ChartData> chartData = [];

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  void _calculateGraphData() {
    final colors = Theme.of(context).customColors;

    double liquidRatio = 0.40;
    double growthRatio = 0.35;
    double debtRatio = 0.25;

    double liquidAmount = savingsAmount * liquidRatio;
    double growthAmount = savingsAmount * growthRatio;
    double debtAmount = savingsAmount * debtRatio;

    chartData = [
      ChartData(
          'Liquid', liquidAmount, colors.selectedItemColor.withOpacity(0.8)),
      ChartData(
          'Growth', growthAmount, colors.selectedItemColor.withOpacity(0.5)),
      ChartData('Debt', debtAmount, colors.selectedItemColor.withOpacity(0.2)),
    ];

    setState(() {
      showChart = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildContents(),
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
      ),
    );
  }

  Widget buildContents() {
    final colors = Theme.of(context).customColors;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionText(),
            const SizedBox(height: 20),
            SavingsAmountWidget(
              onValuesChanged:
                  (double savings, DateTime? start, DateTime? end) {
                setState(() {
                  savingsAmount = savings;
                  startDate = start;
                  endDate = end;
                });
              },
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 130,
                child: ButtonWidget(
                  color: colors.primary,
                  btnContent: "Calculate",
                  onTap: _calculateGraphData,
                ),
              ),
            ),
            if (showChart) _buildChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionText() {
    final textStyles = Theme.of(context).customTextStyles;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(widget.model.question, style: textStyles.mediumNormal),
    );
  }

  Widget _buildChart() {
    final textStyles = Theme.of(context).customTextStyles;

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      borderColor: Colors.transparent,
      primaryXAxis: CategoryAxis(
          labelRotation: -15,
          labelStyle: textStyles.smallBold,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          autoScrollingDelta: 10),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        labelStyle: TextStyle(fontSize: 0),
      ),
      series: <CartesianSeries>[
        StackedColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.amount,
          pointColorMapper: (ChartData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double amount;
  final Color color;

  ChartData(this.category, this.amount, this.color);
}
