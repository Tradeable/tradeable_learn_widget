import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class QuizQuestionOption extends StatelessWidget {
  final String option;
  final Function(String option) onTap;
  final String? selectedOption;
  final String? correctResponse;
  final AutoSizeGroup? group;

  const QuizQuestionOption(
      {super.key,
      required this.option,
      required this.onTap,
      required this.selectedOption,
      this.group,
      this.correctResponse});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return InkWell(
      onTap: () {
        onTap(option);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colors.cardColorSecondary.withOpacity(0.1),
              border: Border.all(
                  color: selectedOption == option
                      ? correctResponse == option
                          ? colors.bullishColor
                          : colors.borderColorPrimary
                      : correctResponse == option
                          ? colors.bullishColor
                          : colors.borderColorSecondary)),
          child: Center(
            child: AutoSizeText(option,
                group: group,
                maxLines: 1,
                minFontSize: 10,
                maxFontSize: 20,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: colors.primary)),
          )),
    );
  }
}
