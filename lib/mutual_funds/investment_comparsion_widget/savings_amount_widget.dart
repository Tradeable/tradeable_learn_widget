import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SavingsAmountWidget extends StatefulWidget {
  final Function(double, DateTime?, DateTime?) onValuesChanged;

  const SavingsAmountWidget({super.key, required this.onValuesChanged});

  @override
  State<SavingsAmountWidget> createState() => _SavingsAmountWidgetState();
}

class _SavingsAmountWidgetState extends State<SavingsAmountWidget> {
  double _currentSliderValue = 0;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text("Monthly Savings Amount", style: textStyles.mediumBold),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  "₹ ${_currentSliderValue.toStringAsFixed(0)}",
                  style: textStyles.largeBold,
                ),
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
          ),
        ),
        const SizedBox(height: 20),
        _buildDatePickers(),
      ],
    );
  }

  Widget _buildDatePickers() {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
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
      ),
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
                backgroundColor: Colors.transparent,
                elevation: 0),
            child: Text(
                date != null
                    ? DateFormat('MM-yyyy').format(date)
                    : 'Select $label',
                style: textStyles.smallNormal
                    .copyWith(color: colors.selectedItemColor)),
          ),
        ),
      ],
    );
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
      _updateValues();
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
      _updateValues();
    }
  }

  void _updateValues() {
    widget.onValuesChanged(_currentSliderValue, startDate, endDate);
  }
}
