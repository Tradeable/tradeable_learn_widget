import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class DragAndDropMatch extends StatefulWidget {
  final LadderModel model;
  final VoidCallback onNextClick;

  const DragAndDropMatch(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<DragAndDropMatch> createState() => _DragAndDropMatchState();
}

class _DragAndDropMatchState extends State<DragAndDropMatch> {
  List<LadderUnit> units = [];
  List<DraggableOption> options = [];
  int correctAnswerCount = 0;
  late LadderModel model;
  bool showErrorBorder = false;
  Color errorColor = Colors.red;

  @override
  void initState() {
    model = widget.model;

    for (int i = 0; i < model.phraseColumn.length; i++) {
      units.add(LadderUnit(
          phrase: model.phraseColumn[i], value: model.valueColumn[i]));
      if (model.phraseColumn[i].model.isQuestion) {
        correctAnswerCount++;
        options.add(DraggableOption(
            type: "phrase", option: model.phraseColumn[i].model.value));
      }
      if (model.valueColumn[i].model.isQuestion) {
        correctAnswerCount++;
        options.add(DraggableOption(
            type: "value", option: model.valueColumn[i].model.value));
      }
    }
    options.shuffle();
    if (widget.model.type != "fno_scenario_1") {
      options.add(DraggableOption(
          type: "phrase", option: Random().nextInt(10).toString()));
      options.add(DraggableOption(
          type: "value", option: Random().nextInt(20).toString()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            model.title ?? "",
            style: textStyles.smallNormal,
          ),
        ),
        const SizedBox(height: 10),
        QuestionWidget(question: model.question),
        const SizedBox(height: 10),
        renderLadderContainer(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: MarkdownBody(
            data: model.content1 ?? "",
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                    h3: textStyles.largeBold.copyWith(fontSize: 28),
                    strong: textStyles.mediumBold,
                    p: textStyles.mediumNormal),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Options", style: textStyles.mediumBold),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: colors.borderColorSecondary.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: options.map((option) {
                    switch (option.state) {
                      case DraggableOptionState.origin:
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: buildDraggableOption(option),
                        );
                      case DraggableOptionState.dragging:
                      case DraggableOptionState.snapped:
                        return Container();
                      default:
                        return Container();
                    }
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        (model.content2 ?? "").isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: MarkdownBody(
                  data: model.content2 ?? "",
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                          h3: textStyles.largeBold.copyWith(fontSize: 28),
                          strong: textStyles.mediumBold,
                          p: textStyles.mediumNormal),
                ),
              )
            : Container(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: answeredAllCorrectly() ? colors.primary : colors.secondary,
              btnContent: "Next",
              onTap: () {
                if (answeredAllCorrectly()) {
                  widget.onNextClick();
                }
              }),
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

  Widget renderLadderUnit(LadderUnit ladderUnit) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: ladderUnit.phrase.model.isQuestion
                ? buildDragTarget(ladderUnit.phrase)
                : Text(
                    ladderUnit.phrase.model.value,
                    textAlign: TextAlign.center,
                    style: textStyles.mediumNormal,
                  ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10),
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: ladderUnit.value.model.isQuestion
                        ? Colors.transparent
                        : colors.borderColorPrimary),
              ),
              child: Center(
                child: ladderUnit.value.model.isQuestion
                    ? buildDragTarget(ladderUnit.value)
                    : Text(
                        ladderUnit.value.model.value,
                        textAlign: TextAlign.center,
                        style: textStyles.mediumNormal,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDragTarget(LadderCell e) {
    final colors = Theme.of(context).customColors;

    return DragTarget<DraggableOption>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return e.capturedOption == null
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: colors.secondary),
                    borderRadius: BorderRadius.circular(12)))
            : buildDraggableOption(e.capturedOption!);
      },
      onAcceptWithDetails: (DragTargetDetails<DraggableOption> details) {
        setState(() {
          details.data.state = DraggableOptionState.snapped;
          options
              .removeWhere((element) => element.option == details.data.option);
          if (details.data.option == e.model.value) {
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

          if (answeredAllCorrectly()) {
            // widget.node.edges!.length > 1
            //     ? _showBottomSheet(context)
            //     : widget.onFinish(
            //         widget.node.edges?.first.pathId ?? "finished", true);
            //todo
            // finish(widget.node.edges?.first.pathId ?? "finished", true);
          }
        });
      },
    );
  }

  bool answeredAllCorrectly() {
    int correctCount = 0;
    for (LadderUnit unit in units) {
      if (unit.phrase.capturedOption?.isSnappedCorrectly == true) {
        correctCount++;
      }

      if (unit.value.capturedOption?.isSnappedCorrectly == true) {
        correctCount++;
      }
    }
    return correctCount == correctAnswerCount;
  }

  Widget buildDraggableOption(DraggableOption option) {
    return Draggable<DraggableOption>(
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

          for (LadderUnit unit in units) {
            if (unit.phrase.capturedOption?.option == option.option) {
              unit.phrase.capturedOption = null;
            }
            if (unit.value.capturedOption?.option == option.option) {
              unit.value.capturedOption = null;
            }
          }
        });
      },
      onDragCompleted: () {
        showError(option.isSnappedCorrectly);
      },
    );
  }

  void showError(bool isSnappedCorrectly) {
    final colors = Theme.of(context).customColors;

    setState(() {
      showErrorBorder = true;
      if (isSnappedCorrectly) {
        errorColor = colors.bullishColor;
      } else {
        errorColor = colors.bearishColor;
      }
    });
  }

  Widget renderOption(DraggableOption option) {
    final colors = Theme.of(context).customColors;

    Color optionBgColor = colors.selectedItemColor;
    switch (option.state) {
      case DraggableOptionState.origin:
      case DraggableOptionState.dragging:
        optionBgColor = colors.selectedItemColor;
        break;
      case DraggableOptionState.snapped:
        optionBgColor = option.isSnappedCorrectly
            ? colors.bullishColor
            : colors.bearishColor;
        break;
    }
    return Material(
      child: Container(
        decoration: BoxDecoration(
            // color: optionBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: optionBgColor)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: AutoSizeText(option.option,
                maxFontSize: 18,
                minFontSize: 12,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
