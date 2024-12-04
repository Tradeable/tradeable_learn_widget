import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/ladder_widget/bricks_widget.dart';
import 'package:tradeable_learn_widget/ladder_widget/dotted_border_container.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_container.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/learn_error_border.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LadderWidgetMain extends StatefulWidget {
  final LadderModel ladderModel;
  final VoidCallback onNextClick;

  const LadderWidgetMain(
      {super.key, required this.ladderModel, required this.onNextClick});

  @override
  State<LadderWidgetMain> createState() => _LadderWidgetMainState();
}

class _LadderWidgetMainState extends State<LadderWidgetMain> {
  List<DraggableOption> options = [];
  int correctAnswerCount = 0;
  late LadderModel model;
  bool showErrorBorder = false;

  @override
  void initState() {
    model = widget.ladderModel;

    for (int i = 0; i < model.phraseColumn.length; i++) {
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
    super.initState();
  }

  void showError() {
    setState(() {
      showErrorBorder = true;
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showErrorBorder = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;
    return LearnErrorBorder(
      showErrorBody: showErrorBorder,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: constraints.maxHeight * 0.11, child: renderHeader()),
              SizedBox(
                  height: constraints.maxHeight * 0.66,
                  child: renderLadderContainer(BoxConstraints(
                      maxHeight: constraints.maxHeight * 0.66,
                      maxWidth: constraints.maxWidth / 4))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: constraints.maxHeight * 0.23,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bricks and Rungs", style: textStyles.mediumBold),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                colors.borderColorSecondary.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: options.map((option) {
                          switch (option.state) {
                            case DraggableOptionState.origin:
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                    const Spacer(),
                    ButtonWidget(
                        color: answeredAllCorrectly()
                            ? colors.primary
                            : colors.secondary,
                        btnContent: "Next",
                        onTap: () {
                          widget.onNextClick();
                        }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget renderHeader() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SUB HEADING",
              style: Theme.of(context).customTextStyles.smallBold),
          Text(
            model.question,
            style: Theme.of(context).customTextStyles.smallNormal,
          ),
        ],
      ),
    );
  }

  Widget renderLadderContainer(BoxConstraints constranints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BricksWidget(
            values: model.phraseColumn,
            buildDragTarget: buildDragTarget,
            constraints: constranints),
        const SizedBox(width: 20),
        LadderContainer(
            phrases: model.valueColumn,
            buildDragTarget: buildDragTarget,
            constraints: constranints)
      ],
    );
  }

  Widget buildDragTarget(LadderCell cell) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return DragTarget<DraggableOption>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return cell.capturedOption == null
            ? DottedBorderWidget(
                backgroundColor: Colors.transparent,
                borderColor: colors.borderColorPrimary,
                child: Center(
                  child: Text("         ", style: textStyles.largeBold),
                ),
              )
            : buildDraggableOption(cell.capturedOption!);
      },
      onAcceptWithDetails: (DragTargetDetails<DraggableOption> details) {
        setState(() {
          details.data.state = DraggableOptionState.snapped;
          options
              .removeWhere((element) => element.option == details.data.option);
          if (details.data.option == cell.model.value) {
            details.data.isSnappedCorrectly = true;
          } else {
            details.data.isSnappedCorrectly = false;
            showError();
          }
          if (cell.capturedOption == null) {
            cell.capturedOption = details.data;
          } else {
            cell.capturedOption?.state = DraggableOptionState.origin;
            options.add(cell.capturedOption!);
            cell.capturedOption = details.data;
          }

          if (answeredAllCorrectly()) {
            setState(() {});
            //todo
            // finish(widget.node.edges?.first.pathId ?? "finished", true);
          }
        });
      },
    );
  }

  bool answeredAllCorrectly() {
    int correctCount = 0;
    for (int i = 0; i < model.phraseColumn.length; i++) {
      if (model.phraseColumn[i].capturedOption?.isSnappedCorrectly == true) {
        correctCount++;
      }
      if (model.valueColumn[i].capturedOption?.isSnappedCorrectly == true) {
        correctCount++;
      }
    }
    return correctCount == correctAnswerCount;
  }

  Widget buildDraggableOption(DraggableOption option) {
    return Draggable<DraggableOption>(
      data: option,
      feedback: Material(
          type: MaterialType.transparency, child: renderOption(option)),
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

          for (int i = 0; i < model.phraseColumn.length; i++) {
            if (model.phraseColumn[i].capturedOption?.option == option.option) {
              model.phraseColumn[i].capturedOption = null;
            }
            if (model.valueColumn[i].capturedOption?.option == option.option) {
              model.valueColumn[i].capturedOption = null;
            }
          }
        });
      },
    );
  }

  Widget renderOption(DraggableOption option) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
          color: option.type == "phrase"
              ? colors.cardColorPrimary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.primary, width: 1)),
      child: Center(
        child: Text(
          option.option,
          style: textStyles.smallBold,
        ),
      ),
    );
  }
}
