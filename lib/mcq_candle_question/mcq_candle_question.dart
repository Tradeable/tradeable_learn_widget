import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mcq_candle_question/mcq_candle_model.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class MCQCandleQuestion extends StatefulWidget {
  final MCQCandleModel model;
  final VoidCallback onNextClick;

  const MCQCandleQuestion(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<MCQCandleQuestion> createState() => _MCQCandleQuestionState();
}

class _MCQCandleQuestionState extends State<MCQCandleQuestion> {
  late MCQCandleModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderQuestion(),
            Expanded(child: renderOptionsWithScroll()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: ButtonWidget(
                  color: (model.userResponse ?? "").isNotEmpty
                      ? colors.primary
                      : colors.secondary,
                  btnContent: "Submit",
                  onTap: () {
                    model.state == MCQCandleQuestionState.submitResponse
                        ? submitResponse()
                        : () {};
                  }),
            )
          ],
        );
      },
    );
  }

  Widget renderQuestion() {
    final textStyles = Theme.of(context).customTextStyles;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(model.question, style: textStyles.mediumNormal),
    );
  }

  Widget renderOptionsWithScroll() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: model.options
              .map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: QuizQuestionOption(
                    option: option,
                    correctResponse: model.correctResponse,
                    onTap: (selectedOption) {
                      setState(() {
                        model.userResponse = selectedOption;
                      });
                      showAnimation();
                    },
                    selectedOption: model.userResponse,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void showAnimation() {
    setState(() {
      model.state = MCQCandleQuestionState.submitResponse;
    });
    if (model.correctResponse == model.userResponse) {
      setState(() {
        model.isCorrect = true;
      });
    }
    submitResponse();
    // finish(widget.node.edges?.first.pathId ?? "finished", model.isCorrect);
  }

  void submitResponse() {
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

class QuizQuestionOption extends StatelessWidget {
  final String option;
  final Function(String option) onTap;
  final String? selectedOption;
  final String? correctResponse;

  const QuizQuestionOption({
    super.key,
    required this.option,
    required this.onTap,
    required this.selectedOption,
    this.correctResponse,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return InkWell(
      onTap: () {
        onTap(option);
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: selectedOption != option
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colors.cardColorSecondary),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(option, fit: BoxFit.fill),
                ),
              )
            : Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: selectedOption == option
                          ? (correctResponse == option
                              ? colors.bullishColor
                              : colors.bearishColor)
                          : colors.borderColorPrimary,
                      width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(option, fit: BoxFit.fill),
                ),
              ),
      ),
    );
  }
}
