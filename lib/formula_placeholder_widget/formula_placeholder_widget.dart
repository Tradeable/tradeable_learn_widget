import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/formula_placeholder_widget/formula_placeholder_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class FormulaPlaceholderWidget extends StatefulWidget {
  final FormulaPlaceHolderModel model;

  const FormulaPlaceholderWidget({super.key, required this.model});

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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                model.title,
                style: textStyles.mediumBold,
              ),
            ),
            Text(model.situation, style: textStyles.mediumNormal),
            const SizedBox(height: 20),
            Column(
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
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  height: 60,
                                  padding: const EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  color: model
                                          .formulaValues[model.questions[i]]!
                                          .isEmpty
                                      ? colors.borderColorSecondary
                                      : colors.bullishColor,
                                  child: Center(
                                    child: Text(
                                      model.formulaValues[model.questions[i]]!
                                              .isEmpty
                                          ? ""
                                          : model.formulaValues[
                                              model.questions[i]]!,
                                      textAlign: TextAlign.center,
                                      style: textStyles.smallNormal,
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
                                    model.formulaValues[model.questions[i]] =
                                        details.data.optionText;
                                    model.options.remove(details.data);
                                  });
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
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
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Options",
                style: textStyles.mediumBold,
              ),
            ),
            const SizedBox(height: 8.0),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 2.5,
              ),
              itemCount: model.options.length,
              itemBuilder: (context, index) {
                return Draggable<DraggableFormulaOption>(
                  data: model.options[index],
                  feedback: buildDraggableItem(model.options[index].optionText),
                  childWhenDragging: Container(),
                  child: buildDraggableItem(model.options[index].optionText),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDraggableItem(String text) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Material(
      child: Container(
        width: 120,
        height: 40,
        alignment: Alignment.center,
        color: colors.selectedItemColor,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyles.mediumBold,
          ),
        ),
      ),
    );
  }
}
