import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_formation/candle_formation_model.dart';

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
    return InkWell(
      onTap: () {
        onTap(option.displayName);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: state == CandleFormationState.submitResponse
                ? (incorrectResponse!.contains(option.optionId))
                ? selectedOptions.contains(option.optionId)
                ? Colors.red
                : const Color(0xFF252A34)
                : !incorrectResponse!.contains(option.optionId) &&
                !selectedOptions.contains(option.optionId)
                ? const Color(0xFF252A34)
                : Colors.green
                : selectedOptions.contains(option.optionId)
                ? Colors.orange
                : const Color(0xFF252A34),
            borderRadius: BorderRadius.circular(10),
          ),
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
                      style: const TextStyle(
                        color: Colors.white,
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
              ],
            ),
          )),
    );
  }
}