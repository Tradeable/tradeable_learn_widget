import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/ladder_widget/bricks_widget.dart';
import 'package:tradeable_learn_widget/ladder_widget/dotted_border_container.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_container.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/learn_error_border.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/utils/widget_bottom_container.dart';

class LadderWidgetMain extends StatefulWidget {
  final LadderModel ladderModel;
  final VoidCallback onNextClick;
  final VoidCallback? onMenuClick;

  const LadderWidgetMain(
      {super.key,
      required this.ladderModel,
      required this.onNextClick,
      this.onMenuClick});

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
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: LearnErrorBorder(
          showErrorBody: showErrorBorder,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionWidget(question: model.question),
                      const SizedBox(height: 16),
                      renderLadderContainer(BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.66,
                        maxWidth: MediaQuery.of(context).size.width / 4,
                      )),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Bricks and Rungs",
                            style: textStyles.mediumBold),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: colors.borderColorSecondary
                                  .withAlpha((0.6 * 255).round())),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: options.map((option) {
                            switch (option.state) {
                              case DraggableOptionState.origin:
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: buildDraggableOption(option),
                                );
                              case DraggableOptionState.dragging:
                              case DraggableOptionState.snapped:
                                return Container();
                            }
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              WidgetBottomContainer(
                onMenuClick: () => widget.onMenuClick,
                buttonWidget: ButtonWidget(
                  color: answeredAllCorrectly()
                      ? colors.primary
                      : colors.secondary,
                  btnContent: "Next",
                  onTap: () {
                    if (answeredAllCorrectly()) {
                      widget.onNextClick();
                    }
                  },
                ),
              )
            ],
          ),
        ),
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
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

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
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
          color: option.type == "phrase"
              ? colors.cardColorPrimary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colors.borderColorPrimary, width: 1)),
      child: Center(
        child: Text(
          option.option,
          style: textStyles.smallBold,
        ),
      ),
    );
  }
}
