import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/column_match/column_data_model.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ColumnMatch extends StatefulWidget {
  final ColumnModel model;
  final VoidCallback onNextClick;

  const ColumnMatch(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<ColumnMatch> createState() => _ColumnMatchState();
}

class _ColumnMatchState extends State<ColumnMatch> {
  List<ColumnUnit> units = [];
  List<ColumnDraggableOption> options = [];
  int correctAnswerCount = 0;
  late ColumnModel model;

  @override
  void initState() {
    model = widget.model;

    for (int i = 0; i < model.phraseColumn.length; i++) {
      units.add(ColumnUnit(
          phrase: model.phraseColumn[i], value: model.valueColumn[i]));
      if (model.phraseColumn[i].model.isQuestion) {
        correctAnswerCount++;
        options.add(ColumnDraggableOption(
            option: model.phraseColumn[i].model.value,
            position: model.phraseColumn[i].model.position));
      }
      if (model.valueColumn[i].model.isQuestion) {
        correctAnswerCount++;
        options.add(ColumnDraggableOption(
            option: model.valueColumn[i].model.value,
            position: model.valueColumn[i].model.position));
      }
    }
    options.shuffle();
    super.initState();
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(model.title ?? "", style: textStyles.largeBold),
                ),
                QuestionWidget(question: model.question),
                const SizedBox(height: 30),
                renderLadderContainer(),
                const SizedBox(height: 30),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 4.5,
                  padding: const EdgeInsets.all(10),
                  children: options.map((e) {
                    switch (e.state) {
                      case DraggableOptionState.origin:
                        return buildDraggableOption(e);
                      case DraggableOptionState.dragging:
                      case DraggableOptionState.snapped:
                        return Container();
                    }
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: ButtonWidget(
            color: answeredAllCorrectly() ? colors.primary : colors.secondary,
            btnContent: "Next",
            onTap: () {
              widget.onNextClick();
            },
          ),
        ),
      ],
    );
  }

  Widget renderLadderContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: units.map((e) => renderLadderUnit(e)).toList(),
          ),
        )
      ],
    );
  }

  Widget renderLadderUnit(ColumnUnit unit) {
    final textStyles = Theme.of(context).customTextStyles;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Center(
              child: unit.phrase.model.isQuestion
                  ? buildDragTarget(unit.phrase)
                  : Text(
                      unit.phrase.model.value,
                      textAlign: TextAlign.center,
                      style: textStyles.mediumNormal,
                    )),
        ),
        Flexible(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 150,
            height: 50,
            child: Center(
              child: unit.value.model.isQuestion
                  ? buildDragTarget(unit.value)
                  : Text(
                      unit.value.model.value,
                      textAlign: TextAlign.center,
                      style: textStyles.mediumNormal,
                    ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildDragTarget(ColumnCell e) {
    final textStyles = Theme.of(context).customTextStyles;

    return DragTarget<ColumnDraggableOption>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return e.capturedOption == null
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "     ?     ",
                      style: textStyles.mediumNormal,
                    ),
                  ),
                ),
              )
            : buildDraggableOption(e.capturedOption!);
      },
      onAcceptWithDetails: (DragTargetDetails<ColumnDraggableOption> details) {
        setState(() {
          details.data.state = DraggableOptionState.snapped;
          options
              .removeWhere((element) => element.option == details.data.option);
          if (details.data.position == e.model.position) {
            details.data.isSnappedCorrectly = true;
          } else {
            details.data.isSnappedCorrectly = false;
          }
          if (e.capturedOption == null) {
            e.capturedOption = details.data;
          } else {
            e.capturedOption?.state = DraggableOptionState.origin;
            options.add(e.capturedOption!);
            e.capturedOption = details.data;
          }
        });
      },
    );
  }

  bool answeredAllCorrectly() {
    int correctCount = 0;
    for (ColumnUnit unit in units) {
      if (unit.phrase.capturedOption?.isSnappedCorrectly == true) {
        correctCount++;
      }

      if (unit.value.capturedOption?.isSnappedCorrectly == true) {
        correctCount++;
      }
    }
    return correctCount == correctAnswerCount;
  }

  Widget buildDraggableOption(ColumnDraggableOption option) {
    return Draggable<ColumnDraggableOption>(
      data: option,
      feedback: renderOption(option),
      childWhenDragging: Container(),
      child: renderOption(option),
      onDraggableCanceled: (velocity, offset) {
        setState(() {
          option.state = DraggableOptionState.origin;
        });
      },
      onDragStarted: () {
        setState(() {
          if (!options.contains(option)) {
            option.state = DraggableOptionState.dragging;
            options.add(option);
          }

          for (ColumnUnit unit in units) {
            if (unit.phrase.capturedOption?.option == option.option) {
              unit.phrase.capturedOption = null;
            }
            if (unit.value.capturedOption?.option == option.option) {
              unit.value.capturedOption = null;
            }
          }
        });
      },
    );
  }

  Widget renderOption(ColumnDraggableOption option) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    Color optionBgColor = colors.buttonColor;
    switch (option.state) {
      case DraggableOptionState.origin:
      case DraggableOptionState.dragging:
        optionBgColor = colors.buttonColor;
        break;
      case DraggableOptionState.snapped:
        optionBgColor = option.isSnappedCorrectly
            ? colors.bullishColor
            : colors.bearishColor;
        break;
    }
    return Material(
      color: colors.buttonColor,
      child: Container(
        decoration: BoxDecoration(
            color: optionBgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.borderColorPrimary)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: AutoSizeText(
              option.option,
              minFontSize: 12,
              maxFontSize: 20,
              textScaleFactor: 1,
              style: textStyles.mediumNormal,
            ),
          ),
        ),
      ),
    );
  }
}
