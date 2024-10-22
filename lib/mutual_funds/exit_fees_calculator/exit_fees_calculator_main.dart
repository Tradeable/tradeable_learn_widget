import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/exit_fees_calculator/exit_fees_calculator_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ExitFeesCalculatorMain extends StatefulWidget {
  final ExitFeeCalculatorModel model;

  const ExitFeesCalculatorMain({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _ExitFeesCalculatorWidget();
}

class _ExitFeesCalculatorWidget extends State<ExitFeesCalculatorMain> {
  late ExitFeeCalculatorModel model;
  final Map<String, TextEditingController> controllers = {};
  double exitFeePercentage = 0.0;
  double calculatedExitFee = 0.0;

  @override
  void initState() {
    model = widget.model;
    model.inputValues.forEach((key, value) {
      controllers[key] = TextEditingController(text: value);
    });
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void calculateExitFee() {
    final redemptionAmountText = controllers['Redemption Amount']?.text;
    if (redemptionAmountText != null && redemptionAmountText.isNotEmpty) {
      final redemptionAmount = double.tryParse(redemptionAmountText) ?? 0;
      calculatedExitFee = redemptionAmount * (exitFeePercentage / 100);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.question,
                    style: textStyles.mediumBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ...model.inputValues.keys.map((field) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child:
                                  Text(field, style: textStyles.mediumNormal)),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: controllers[field],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Exit Fee %', style: textStyles.mediumBold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            exitFeePercentage =
                                (exitFeePercentage - 0.1).clamp(0, 5);
                          });
                        },
                      ),
                      Slider(
                        value: exitFeePercentage,
                        min: 0,
                        max: 5,
                        divisions: 50,
                        label: exitFeePercentage.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            exitFeePercentage = value;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            exitFeePercentage =
                                (exitFeePercentage + 0.1).clamp(0, 5);
                          });
                        },
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: colors.borderColorSecondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${exitFeePercentage.toStringAsFixed(1)}%',
                          style: textStyles.mediumNormal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Exit Fees", style: textStyles.mediumBold),
                        const SizedBox(height: 10),
                        Container(
                          width: 120,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: colors.borderColorSecondary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              calculatedExitFee.toStringAsFixed(2),
                              style: textStyles.mediumNormal,
                            ),
                          ),
                        ),
                      ],
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
