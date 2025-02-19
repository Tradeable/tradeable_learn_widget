import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/formula_placeholder_widget/formula_placeholder_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class FormulaPlaceholderWidget extends StatefulWidget {
  final FormulaPlaceHolderModel model;
  final VoidCallback onNextClick;

  const FormulaPlaceholderWidget(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<FormulaPlaceholderWidget> createState() =>
      _FormulaPlaceholderWidgetState();
}

class _FormulaPlaceholderWidgetState extends State<FormulaPlaceholderWidget> {
  late FormulaPlaceHolderModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.title,
                  style: textStyles.mediumBold,
                ),
              ),
              QuestionWidget(question: model.situation),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < model.questions.length; i++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: model.hideQuestions
                                    ? Container()
                                    : Text(
                                        model.questions[i],
                                        style: textStyles.mediumNormal
                                            .copyWith(fontSize: 20),
                                      ),
                              ),
                              Flexible(
                                flex: 1,
                                child: DragTarget<DraggableFormulaOption>(
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(4),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: colors.borderColorPrimary),
                                          color: model
                                                  .formulaValues[
                                                      model.questions[i]]!
                                                  .isEmpty
                                              ? Colors.transparent
                                              : colors.bullishColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          model
                                                  .formulaValues[
                                                      model.questions[i]]!
                                                  .isEmpty
                                              ? ""
                                              : model.formulaValues[
                                                  model.questions[i]]!,
                                          textAlign: TextAlign.center,
                                          style: textStyles.mediumNormal,
                                        ),
                                      ),
                                    );
                                  },
                                  onAcceptWithDetails:
                                      (DragTargetDetails<DraggableFormulaOption>
                                          details) {
                                    if (model.correctOptionTargets[
                                            details.data.optionText] ==
                                        model.questions[i]) {
                                      setState(() {
                                        model.formulaValues[
                                                model.questions[i]] =
                                            details.data.optionText;
                                        model.options.remove(details.data);
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (i < model.questions.length - 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(model.formulas[i],
                                    style: textStyles.mediumBold),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Text("Options", style: textStyles.mediumBold),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: model.options.length,
                      itemBuilder: (context, index) {
                        return Draggable<DraggableFormulaOption>(
                          data: model.options[index],
                          feedback: buildDraggableItem(
                              model.options[index].optionText),
                          childWhenDragging: Container(),
                          child: buildDraggableItem(
                              model.options[index].optionText),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
            color: model.options.isEmpty ? colors.primary : colors.secondary,
            btnContent: "Next",
            onTap: () {
              if (model.options.isEmpty) {
                widget.onNextClick();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildDraggableItem(String text) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Material(
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.cardColorSecondary),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyles.mediumNormal,
          ),
        ),
      ),
    );
  }
}
