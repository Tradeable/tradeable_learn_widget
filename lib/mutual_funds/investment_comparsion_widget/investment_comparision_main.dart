import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_returns_table.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/expandable_widget.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_comparsion_widget/savings_amount_widget.dart';
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

  final List<String> fundOptions = ['Fund A', 'Fund B', 'Fund C'];

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpandableWidget(
                    title: "Fund Name",
                    subtitle: "Select an Investment Fund",
                    content: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.secondary),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        hint: const Text("Select Fund"),
                        value: selectedFund,
                        items: fundOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFund = newValue;
                            _updateAvgReturns();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SavingsAmountWidget(
                    onValuesChanged:
                        (double savings, DateTime? start, DateTime? end) {
                      setState(() {
                        savingsAmount = savings;
                        startDate = start;
                        endDate = end;
                        _updateAvgReturns();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (avgReturns.any((element) => element != 0.0))
                    ExpandableWidget(
                      title: "Investment Returns",
                      subtitle: "View Your Investment Analysis",
                      content: InvestmentReturnsTable(
                        avgReturns: avgReturns,
                        onIconDropped: (icon, index) {},
                      ),
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
      ),
    );
  }
}
