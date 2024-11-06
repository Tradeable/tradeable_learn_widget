import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/exit_fees_calculator/animated_text_widget.dart';
import 'package:tradeable_learn_widget/mutual_funds/exit_fees_calculator/exit_fees_calculator_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:dart_eval/dart_eval.dart';

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
  int currentInputIndex = 0;
  bool animationCompleted = false;
  bool showExitFeeSection = false;

  @override
  void initState() {
    model = widget.model;
    model.inputValues.forEach((key, value) {
      final controller = TextEditingController(text: value);
      controller.addListener(() {
        calculateExitFee();
      });
      controllers[key] = controller;
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
    final navAtInvestmentText = controllers['NAV at time of investment']?.text;
    final totalInvestmentText = controllers['Total Investment']?.text;
    final currentNavText = controllers['Current NAV']?.text;
    final redemptionAmountText = controllers['Redemption Amount']?.text;

    if (navAtInvestmentText != null &&
        totalInvestmentText != null &&
        currentNavText != null &&
        redemptionAmountText != null &&
        navAtInvestmentText.isNotEmpty &&
        totalInvestmentText.isNotEmpty &&
        currentNavText.isNotEmpty &&
        redemptionAmountText.isNotEmpty) {
      final navAtInvestment = double.tryParse(navAtInvestmentText) ?? 0;
      final totalInvestment = double.tryParse(totalInvestmentText) ?? 0;
      final currentNav = double.tryParse(currentNavText) ?? 0;
      final redemptionAmount = double.tryParse(redemptionAmountText) ?? 0;

      final formula = model.program
          .replaceAll('NAV_AT_INVESTMENT', navAtInvestment.toString())
          .replaceAll('TOTAL_INVESTMENT', totalInvestment.toString())
          .replaceAll('CURRENT_NAV', currentNav.toString())
          .replaceAll('REDEMPTION_AMOUNT', redemptionAmount.toString())
          .replaceAll('EXIT_FEE_PERCENTAGE', exitFeePercentage.toString());

      calculatedExitFee = eval(formula) as double;
      setState(() {});
    } else {
      calculatedExitFee = 0.0;
      setState(() {});
    }
  }

  void onAnimationComplete() {
    setState(() {
      animationCompleted = true;
    });
  }

  void onSubmit() {
    if (currentInputIndex < model.inputValues.keys.length - 1) {
      setState(() {
        currentInputIndex++;
      });
    } else {
      setState(() {
        showExitFeeSection = true;
      });
    }
  }

  void onSliderChange(double value) {
    setState(() {
      exitFeePercentage = value;
      calculateExitFee();
    });
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
                  AnimatedText(
                    text: model.question,
                    style: textStyles.mediumBold,
                    onAnimationComplete: onAnimationComplete,
                  ),
                  const SizedBox(height: 40),
                  if (animationCompleted)
                    ...List.generate(
                      currentInputIndex + 1,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  model.inputValues.keys.elementAt(index),
                                  style: textStyles.mediumNormal,
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: controllers[
                                      model.inputValues.keys.elementAt(index)],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  if (animationCompleted &&
                      currentInputIndex != model.inputValues.length &&
                      !showExitFeeSection)
                    ElevatedButton(
                      onPressed: onSubmit,
                      child: const Text("Submit"),
                    ),
                  if (showExitFeeSection)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child:
                              Text('Exit Fee %', style: textStyles.mediumBold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  exitFeePercentage =
                                      (exitFeePercentage - 0.1).clamp(0, 5);
                                  calculateExitFee();
                                });
                              },
                            ),
                            Slider(
                              value: exitFeePercentage,
                              min: 0,
                              max: 5,
                              divisions: 50,
                              label: exitFeePercentage.toStringAsFixed(1),
                              onChanged: onSliderChange,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  exitFeePercentage =
                                      (exitFeePercentage + 0.1).clamp(0, 5);
                                  calculateExitFee();
                                });
                              },
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: colors.borderColorSecondary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${exitFeePercentage.toStringAsFixed(1)}%',
                                style: textStyles.mediumNormal,
                              ),
                            ),
                          ],
                        ),
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
                                  border: Border.all(
                                      color: colors.borderColorSecondary),
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
