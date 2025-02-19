import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_formation/candle_formation_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class QuizQuestionOption extends StatelessWidget {
  final CandleFormationState state;
  final CandleOption option;
  final Function(String option) onTap;
  final String? selectedOption;
  final List<String>? incorrectResponse;
  final List<String> selectedOptions;

  const QuizQuestionOption(
      {super.key,
      required this.state,
      required this.option,
      required this.onTap,
      required this.selectedOption,
      this.incorrectResponse,
      required this.selectedOptions});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MaterialButton(
        onPressed: () {
          onTap(option.displayName);
        },
        color: state == CandleFormationState.submitResponse
            ? (incorrectResponse!.contains(option.optionId))
                ? selectedOptions.contains(option.optionId)
                    ? colors.bearishColor
                    : colors.buttonColor
                : !incorrectResponse!.contains(option.optionId) &&
                        !selectedOptions.contains(option.optionId)
                    ? colors.buttonColor
                    : colors.bullishColor
            : selectedOptions.contains(option.optionId)
                ? colors.cardColorPrimary
                : colors.buttonColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: state == CandleFormationState.submitResponse
                  ? (incorrectResponse!.contains(option.optionId))
                      ? selectedOptions.contains(option.optionId)
                          ? colors.bearishColor
                          : colors.borderColorPrimary
                      : !incorrectResponse!.contains(option.optionId) &&
                              !selectedOptions.contains(option.optionId)
                          ? colors.borderColorPrimary
                          : colors.bullishColor
                  : selectedOptions.contains(option.optionId)
                      ? colors.borderColorPrimary
                      : colors.borderColorSecondary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AutoSizeText(option.displayName,
                    maxFontSize: 15,
                    minFontSize: 8,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                  state == CandleFormationState.submitResponse
                      ? incorrectResponse!.contains(option.optionId)
                          ? "\u2717"
                          : "\u2713"
                      : "",
                  maxLines: 1,
                  style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
