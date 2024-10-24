import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/investment_analysis_widget/investment_data_table.dart';
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
  bool dataPopulated = false;
  List<double> avgReturns = [0.0, 0.0];
  List<double> pnl = [0.0, 0.0];

  final List<String> fundOptions = ['Fund A', 'Fund B', 'Fund C'];

  void _onCalculate() {
    if (selectedFund != null &&
        startDate != null &&
        endDate != null &&
        savingsAmount > 0) {
      setState(() {
        avgReturns = [5.5, 7.2];
        pnl = [1000.50, 1200.75];
        dataPopulated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child:
                          Text("SIP VS Lump Sum", style: textStyles.largeBold)),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fund name", style: textStyles.mediumBold),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.secondary),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: InputBorder.none, // Remove default border
                            ),
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
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 130,
                      child: ButtonWidget(
                        color: (selectedFund != null &&
                                startDate != null &&
                                endDate != null &&
                                savingsAmount > 0)
                            ? colors.primary
                            : colors.secondary,
                        btnContent: "Calculate",
                        onTap: (selectedFund != null &&
                                startDate != null &&
                                endDate != null &&
                                savingsAmount > 0)
                            ? _onCalculate
                            : () {},
                      ),
                    ),
                  ),
                  //todo add graph
                  const SizedBox(height: 20),
                  if (dataPopulated)
                    InvestmentDataTable(
                      sipInvestmentAmount: savingsAmount,
                      lumpsumInvestmentAmount: savingsAmount * 12,
                      // Example calc
                      avgReturns: avgReturns,
                      pnl: pnl,
                    )
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
