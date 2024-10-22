import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/mf_calculator_widget/mf_calculator_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MfCalculatorMain extends StatefulWidget {
  final MfCalculatorModel model;

  const MfCalculatorMain({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _MfCalculatorMain();
}

class _MfCalculatorMain extends State<MfCalculatorMain> {
  late MfCalculatorModel model;
  double _currentSliderValue = 0;
  DateTime? startDate;
  DateTime? endDate;
  bool showChart = false;
  List<ChartData> chartData = [];

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  void _calculateGraphData() {
    final colors = Theme.of(context).customColors;

    double liquidRatio = 0.40;
    double growthRatio = 0.35;
    double debtRatio = 0.25;

    double liquidAmount = _currentSliderValue * liquidRatio;
    double growthAmount = _currentSliderValue * growthRatio;
    double debtAmount = _currentSliderValue * debtRatio;

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
            _buildSliderSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildDatePickers(),
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

  Widget _buildSliderSection() {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Monthly Savings Amount", style: textStyles.mediumBold),
          const SizedBox(height: 20),
          Text(
            "₹ ${_currentSliderValue.toStringAsFixed(0)}",
            style: textStyles.largeBold,
          ),
          Slider(
            value: _currentSliderValue,
            min: 0,
            max: 10000,
            divisions: 100,
            label: "₹ ${_currentSliderValue.toStringAsFixed(0)}",
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickers() {
    final textStyles = Theme.of(context).customTextStyles;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateColumn("Start Date", startDate, _selectStartDate),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'to',
            style: textStyles.mediumBold,
          ),
        ),
        _buildDateColumn("End Date", endDate, _selectEndDate),
      ],
    );
  }

  Widget _buildDateColumn(
      String label, DateTime? date, VoidCallback onPressed) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyles.mediumBold,
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.axisColor, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Transparent background
                elevation: 0),
            child: Text(
              date != null
                  ? DateFormat('MM-yyyy').format(date)
                  : 'Select $label',
            ),
          ),
        ),
      ],
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
