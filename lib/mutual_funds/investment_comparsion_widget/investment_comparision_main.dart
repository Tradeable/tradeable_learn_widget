import 'package:dart_eval/dart_eval.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/expandable_widget.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/savings_amount_widget.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_returns_table.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/workflow_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class InvestmentComparisionMain extends StatefulWidget {
  const InvestmentComparisionMain({super.key});

  @override
  State<StatefulWidget> createState() => _InvestmentComparsionMain();
}

class _InvestmentComparsionMain extends State<InvestmentComparisionMain> {
  double savingsAmount = 0;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedFund;
  List<double> avgReturns = [0.0, 0.0];
  int currentStepIndex = 0;

  void _updateAvgReturns() {
    if (selectedFund != null &&
        startDate != null &&
        endDate != null &&
        savingsAmount > 0) {
      setState(() {
        avgReturns = [5.5, 7.2];
      });
    }
  }

  bool _isCurrentStepValid() {
    var currentStepId = workflowSteps[currentStepIndex].id;
    var currentStepIsFinal = workflowSteps[currentStepIndex].isFinalStep;
    bool areDatesValid = startDate != null &&
        endDate != null &&
        endDate!.difference(startDate!).inDays >= 30;
    bool avg = avgReturns.any((element) => element != 0.0);

    const program = r'''
    import 'dart:core';
  
    bool isCurrentStepValid(int currentStepId, bool currentStepIsFinal, dynamic selectedFund, bool areDatesValid, double savingsAmount, bool avg) {
      if (currentStepId == 1) {
        return selectedFund != null;
      } else if (currentStepId == 2) {
        return areDatesValid && savingsAmount > 0;
      } else if (currentStepId == 3) {
        return avg;
      } else if (currentStepId == 4) {
        return selectedFund == 'Fund C';
      } else {
        return false;
      }
    }
    ''';

    var result = eval(program, function: 'isCurrentStepValid', args: [
      currentStepId,
      currentStepIsFinal,
      selectedFund,
      areDatesValid,
      savingsAmount,
      avgReturns
    ]);

    return result as bool;
  }

  void _nextStep() {
    if (_isCurrentStepValid()) {
      if (currentStepIndex + 1 != workflowSteps.length) {
        setState(() {
          currentStepIndex++;
        });
      }
    } else {
      var step = workflowSteps[currentStepIndex];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(step.errorMessage)));
    }
  }

  Widget _buildWidgetForStep(int stepId) {
    switch (stepId) {
      case 1:
        return ExpandableWidget(
          title: "Fund Name",
          subtitle: "Select an Investment Fund",
          content: DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: InputBorder.none),
            hint: const Text("Select Fund"),
            value: selectedFund,
            items: ["Fund A", "Fund B", "Fund C"].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedFund = newValue;
                _updateAvgReturns();
                if (newValue == 'Fund C') {
                  _showFundCPrompt();
                }
              });
            },
          ),
        );
      case 2:
        return SavingsAmountWidget(
          initialSavingsAmount: savingsAmount,
          initialStartDate: startDate,
          initialEndDate: endDate,
          onValuesChanged: (double savings, DateTime? start, DateTime? end) {
            setState(() {
              savingsAmount = savings;
              startDate = start;
              endDate = end;
              _updateAvgReturns();
            });
          },
        );
      case 3:
        return ExpandableWidget(
          title: "Investment Returns",
          subtitle: "View Your Investment Analysis",
          content: InvestmentReturnsTable(
            avgReturns: avgReturns,
            onIconDropped: (icon, index) {},
          ),
        );
      case 4:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  void _showFundCPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(workflowSteps[3].prompt),
          content: Text(workflowSteps[3].action),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                  selectedFund = 'Fund A';
                  currentStepIndex++;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                setState(() {
                  currentStepIndex++;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _getCurrentWidget() {
    if (workflowSteps[currentStepIndex].isFinalStep) {
      return Column(
        children: [
          _buildWidgetForStep(1),
          const SizedBox(height: 10),
          _buildWidgetForStep(2),
          const SizedBox(height: 10),
          _buildWidgetForStep(3),
        ],
      );
    } else {
      return _buildWidgetForStep(workflowSteps[currentStepIndex].id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: _getCurrentWidget())),
            Container(
              height: 60,
              padding: const EdgeInsets.all(10),
              child: ButtonWidget(
                color: Theme.of(context).customColors.primary,
                btnContent: "Next",
                onTap: _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
