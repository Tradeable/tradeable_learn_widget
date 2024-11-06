import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/expandable_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SavingsAmountWidget extends StatefulWidget {
  final Function(double, DateTime?, DateTime?) onValuesChanged;
  final double initialSavingsAmount;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const SavingsAmountWidget({
    super.key,
    required this.onValuesChanged,
    this.initialSavingsAmount = 0,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<SavingsAmountWidget> createState() => _SavingsAmountWidgetState();
}

class _SavingsAmountWidgetState extends State<SavingsAmountWidget> {
  late double _currentSliderValue;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialSavingsAmount;
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandableWidget(
          title: "Monthly Savings Amount",
          subtitle: "Set the amount you wish to save monthly",
          content: _buildSavingsContent(),
        ),
        const SizedBox(height: 10),
        ExpandableWidget(
          title: "Date Selection",
          subtitle: "Choose start and end dates",
          content: _buildDateSelectionContent(),
        ),
      ],
    );
  }

  Widget _buildSavingsContent() {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: colors.bullishColor),
              ),
              child: InkWell(
                child: const Icon(Icons.remove),
                onTap: () {
                  setState(() {
                    if (_currentSliderValue > 0) {
                      _currentSliderValue -= 100;
                      _updateValues();
                    }
                  });
                },
              ),
            ),
            Text(
              "₹ ${_currentSliderValue.toStringAsFixed(0)}",
              style: textStyles.largeBold,
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.bullishColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: colors.bullishColor),
              ),
              child: InkWell(
                child: Icon(Icons.add, color: colors.cardBasicBackground),
                onTap: () {
                  setState(() {
                    if (_currentSliderValue < 10000) {
                      _currentSliderValue += 100;
                      _updateValues();
                    }
                  });
                },
              ),
            ),
          ],
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
            _updateValues();
          },
        ),
      ],
    );
  }

  Widget _buildDateSelectionContent() {
    final textStyles = Theme.of(context).customTextStyles;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateColumn("Start Date", startDate, _selectStartDate),
        Text('till', style: textStyles.smallNormal),
        _buildDateColumn("End Date", endDate, _selectEndDate),
      ],
    );
  }

  Widget _buildDateColumn(
      String label, DateTime? date, VoidCallback onPressed) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: colors.borderColorSecondary)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        child: Text(
          date != null ? DateFormat('MM-yyyy').format(date) : 'Select $label',
          style:
              textStyles.smallNormal.copyWith(color: colors.selectedItemColor),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
      _updateValues();
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      _updateValues();
    }
  }

  void _updateValues() {
    widget.onValuesChanged(_currentSliderValue, startDate, endDate);
  }
}
