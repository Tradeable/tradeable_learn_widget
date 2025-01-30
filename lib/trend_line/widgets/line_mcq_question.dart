import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tradeable_learn_widget/trend_line/models/trendline_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LineMCQQuestionWidget extends StatefulWidget {
  final TrendLineModel model;
  final String question;
  final List<String> options;
  final VoidCallback onSubmit;
  final String correctResponse;

  const LineMCQQuestionWidget(
      {super.key,
      required this.model,
      required this.question,
      required this.options,
      required this.onSubmit,
      required this.correctResponse});

  @override
  State<LineMCQQuestionWidget> createState() => _LineMCQQuestionWidgetState();
}

class _LineMCQQuestionWidgetState extends State<LineMCQQuestionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: buildOptions(correctResponse: widget.correctResponse),
    );
  }

  Widget buildOptions({required String? correctResponse}) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 3,
      padding: const EdgeInsets.all(10),
      children: widget.options
          .map(
            (e) => QuizQuestionOption(
              option: e,
              correctResponse: correctResponse,
              onTap: (option) {
                setState(() {
                  widget.model.userResponse = option;
                  widget.onSubmit();
                });
                // model.state = TrendLineQuestionState.submitMCQ2;
              },
              selectedOption: widget.model.userResponse,
            ),
          )
          .toList(),
    );
  }
}

class QuizQuestionOption extends StatelessWidget {
  final String option;
  final Function(String option) onTap;
  final String? selectedOption;
  final String? correctResponse;
  final AutoSizeGroup? group;

  const QuizQuestionOption({
    super.key,
    required this.option,
    required this.onTap,
    required this.selectedOption,
    this.group,
    this.correctResponse,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return InkWell(
      onTap: () {
        onTap(option);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedOption != ""
                    ? selectedOption == option
                        ? correctResponse == option
                            ? colors.bullishColor
                            : colors.bearishColor
                        : correctResponse == option
                            ? colors.bullishColor
                            : colors.cardColorPrimary
                    : colors.cardColorSecondary,
              )),
          child: Center(
            child: AutoSizeText(option,
                group: group,
                maxLines: 1,
                minFontSize: 10,
                maxFontSize: 20,
                style: textStyles.mediumNormal),
          )),
    );
  }
}
