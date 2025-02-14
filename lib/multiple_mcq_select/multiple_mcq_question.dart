import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/multiple_mcq_select/multiple_mcq_model.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class MultipleMCQSelect extends StatefulWidget {
  final MultipleMCQModel model;
  final VoidCallback onNextClick;

  const MultipleMCQSelect(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<MultipleMCQSelect> createState() => _MultipleMCQSelectState();
}

class _MultipleMCQSelectState extends State<MultipleMCQSelect> {
  late MultipleMCQModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionWidget(question: model.question),
          const Spacer(),
          renderOptions(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: ButtonWidget(
              color: colors.primary,
              btnContent: "Submit",
              onTap: () {
                showAnimation();
              },
            ),
          ),
        ],
      );
    });
  }

  Widget renderOptions() {
    switch (model.state) {
      case MultipleMCQQuestionState.loadUI:
        return buildOptions(correctResponse: null);
      case MultipleMCQQuestionState.submitResponse:
        return buildOptions(correctResponse: model.correctResponse);
    }
  }

  Widget buildOptions({required List<String>? correctResponse}) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1 / 0.18,
      padding: const EdgeInsets.all(10),
      children: model.options
          .map(
            (e) => QuestionOptions(
                option: e,
                correctResponse: correctResponse ?? [],
                onTap: (option) {
                  setState(() {
                    if (model.state == MultipleMCQQuestionState.loadUI) {
                      if (model.userResponse.contains(option)) {
                        setState(() {
                          model.userResponse.remove(option);
                        });
                      } else {
                        setState(() {
                          model.userResponse.add(option);
                        });
                      }
                    }
                  });
                },
                userResponses: model.userResponse,
                state: model.state),
          )
          .toList(),
    );
  }

  void showAnimation() {
    setState(() {
      model.state = MultipleMCQQuestionState.submitResponse;
    });
    if (Set.from(model.correctResponse).length ==
            Set.from(model.userResponse).length &&
        Set.from(model.correctResponse).containsAll(model.userResponse)) {
      setState(() {
        model.isCorrect = true;
      });
    }
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => BottomSheetWidget(
            isCorrect: model.isCorrect,
            model: model.explanationV1,
            onNextClick: () {
              widget.onNextClick();
            }));
  }
}

class QuestionOptions extends StatefulWidget {
  final String option;
  final Function(String option) onTap;
  final List<String> correctResponse;
  final AutoSizeGroup? group;
  final List<String> userResponses;
  final MultipleMCQQuestionState state;

  const QuestionOptions(
      {super.key,
      required this.option,
      required this.onTap,
      required this.correctResponse,
      this.group,
      required this.userResponses,
      required this.state});

  @override
  State<QuestionOptions> createState() => _QuestionOptionsState();
}

class _QuestionOptionsState extends State<QuestionOptions> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    Color getColor() {
      if (widget.state == MultipleMCQQuestionState.submitResponse) {
        return widget.correctResponse.contains(widget.option)
            ? colors.bullishColor
            : widget.userResponses.contains(widget.option)
                ? colors.bearishColor
                : colors.cardColorSecondary;
      } else {
        return isTapped ? colors.selectedItemColor : colors.cardColorSecondary;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
        widget.onTap(widget.option);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: getColor())),
        child: Center(
          child: AutoSizeText(widget.option,
              group: widget.group,
              minFontSize: 10,
              maxFontSize: 20,
              textAlign: TextAlign.center,
              style: textStyles.mediumBold.copyWith(color: colors.primary)),
        ),
      ),
    );
  }
}
