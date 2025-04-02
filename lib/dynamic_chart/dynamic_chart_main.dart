import 'package:auto_size_text/auto_size_text.dart';
import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/mcq_arrangment_type.dart';
import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/tasks/wait.task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class DynamicChartWidget extends StatefulWidget {
  final DynamicChartModel model;
  final VoidCallback onNextClick;

  const DynamicChartWidget(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<DynamicChartWidget> createState() => _DynamicChartWidgetState();
}

class _DynamicChartWidgetState extends State<DynamicChartWidget> {
  final GlobalKey<ChartState> _chartKey = GlobalKey();
  late Recipe recipe;

  int taskPointer = 0;
  late Task currentTask;

  AddPromptTask? promptTask;
  bool showNextButton = false;

  @override
  void initState() {
    recipe = widget.model.recipe;
    if (recipe.tasks.isNotEmpty) {
      currentTask = recipe.tasks.first;
      dd();
    }
    super.initState();
  }

  void dd() async {
    await Future.delayed(const Duration(milliseconds: 300));
    onTaskRun();
  }

  void onTaskRun() {
    switch (currentTask.taskType) {
      case TaskType.addData:
        AddDataTask task = currentTask as AddDataTask;
        _chartKey.currentState
            ?.addDataWithAnimation(
                recipe.data.sublist(task.fromPoint, task.tillPoint),
                const Duration(milliseconds: 50))
            .then((value) {
          if (value) {
            onTaskFinish();
          }
        });
        break;
      case TaskType.addIndicator:
        AddIndicatorTask task = currentTask as AddIndicatorTask;
        _chartKey.currentState?.addIndicator(task.indicator);
        onTaskFinish();
        break;
      case TaskType.addLayer:
        AddLayerTask task = currentTask as AddLayerTask;
        _chartKey.currentState?.addLayerAtRegion(task.regionId, task.layer);
        onTaskFinish();
        break;
      case TaskType.addPrompt:
        AddPromptTask task = currentTask as AddPromptTask;
        setState(() {
          promptTask = task;
        });
        onTaskFinish();
        break;
      case TaskType.waitTask:
        setState(() {});
        break;
      case TaskType.addMcq:
        setState(() {});
        break;
    }
  }

  void onTaskFinish() {
    taskPointer += 1;
    if (taskPointer < recipe.tasks.length) {
      currentTask = recipe.tasks[taskPointer];
      onTaskRun();
    }
    if (taskPointer == recipe.tasks.length) {
      if (currentTask.actionType != ActionType.interupt) {
        setState(() {
          showNextButton = true;
        });
      } else {
        widget.onNextClick();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            promptTask != null
                ? Container(
                    height: constraints.maxHeight * 0.16,
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.cardColorSecondary,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) => SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                      child: Container(
                        key: ValueKey(promptTask),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.buttonColor,
                          border: Border.all(color: colors.cardColorSecondary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            promptTask != null && promptTask!.isExplanation
                                ? Row(
                                    children: [
                                      Text("Take Away",
                                          style: textStyles.smallBold),
                                      const SizedBox(width: 6),
                                      // Icon(Icons.volume_up,
                                      //     color: colors.borderColorPrimary)
                                    ],
                                  )
                                : Text("Instruction",
                                    style: textStyles.smallNormal.copyWith(
                                        color: colors.textColorSecondary)),
                            Expanded(
                              child: AutoSizeText(promptTask?.promptText ?? "",
                                  minFontSize: 10,
                                  maxFontSize: 14,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(height: constraints.maxHeight * 0.18),
            SizedBox(
              height: constraints.maxHeight * 0.7,
              child: Chart.from(
                key: _chartKey,
                recipe: recipe,
                onInteraction: (p0, p1) {},
              ),
            ),
            showNextButton
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    child: ButtonWidget(
                        color: colors.primary,
                        btnContent: "Next",
                        onTap: () {
                          widget.onNextClick();
                        }),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    height: constraints.maxHeight * 0.11,
                    child: userActionContainer()),
          ],
        );
      },
    );
  }

  Widget userActionContainer() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    switch (currentTask.taskType) {
      case TaskType.addData:
      case TaskType.addIndicator:
      case TaskType.addLayer:
      case TaskType.addPrompt:
        return Container();
      case TaskType.addMcq:
        return mcqWidget();
      case TaskType.waitTask:
        return ButtonWidget(
          color: colors.primary,
          btnContent: (currentTask as WaitTask).btnText,
          onTap: () => onTaskFinish(),
        );
    }
  }

  Widget mcqWidget() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    Task task = currentTask as AddMcqTask;
    int columns, rows;

    switch ((task as AddMcqTask).arrangementType) {
      case MCQArrangementType.grid1x2:
        columns = 2;
        rows = 1;
        break;
      case MCQArrangementType.grid2x2:
        columns = 2;
        rows = 2;
        break;
      case MCQArrangementType.grid2x3:
        columns = 3;
        rows = 2;
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth =
            (constraints.maxWidth - (10 * (columns - 1))) / columns;
        double itemHeight = (constraints.maxHeight - (10 * (rows - 1))) / rows;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: task.options.map((e) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: InkWell(
                onTap: () => onTaskFinish(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colors.buttonColor,
                    border: Border.all(color: colors.cardColorSecondary),
                  ),
                  child: Center(
                    child: Text(e),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
