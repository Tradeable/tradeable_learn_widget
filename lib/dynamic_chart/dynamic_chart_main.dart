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
                const Duration(milliseconds: 10))
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
      case TaskType.clearTask:
        _chartKey.currentState?.clearChart();
        onTaskFinish();
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

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Define minimum heights for each section
          final minPromptHeight = constraints.maxHeight * 0.1;
          final minChartHeight = constraints.maxHeight * 0.6;
          final minActionHeight = constraints.maxHeight * 0.1;

          // Calculate actual heights based on content
          double promptHeight = promptTask != null
              ? constraints.maxHeight * 0.16
              : minPromptHeight;
          double actionHeight = showNextButton ||
                  currentTask.taskType == TaskType.waitTask ||
                  currentTask.taskType == TaskType.addMcq
              ? constraints.maxHeight * 0.11
              : minActionHeight;

          // Chart gets the remaining space (middle section is flexible)
          double chartHeight =
              constraints.maxHeight - promptHeight - actionHeight;

          // Ensure chart has at least its minimum height
          if (chartHeight < minChartHeight) {
            // If chart would be too small, reduce other sections proportionally
            double deficit = minChartHeight - chartHeight;
            double promptReduction =
                deficit * (promptHeight / (promptHeight + actionHeight));
            double actionReduction =
                deficit * (actionHeight / (promptHeight + actionHeight));

            promptHeight =
                Math.max(minPromptHeight, promptHeight - promptReduction);
            actionHeight =
                Math.max(minActionHeight, actionHeight - actionReduction);
            chartHeight = constraints.maxHeight - promptHeight - actionHeight;
          }

          return Column(
            children: [
              // Section 1: Prompt
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: promptHeight,
                child: promptTask != null
                    ? Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colors.cardColorSecondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
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
                              border:
                                  Border.all(color: colors.cardColorSecondary),
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
                                        ],
                                      )
                                    : Text("Instruction",
                                        style: textStyles.smallNormal.copyWith(
                                            color: colors.textColorSecondary)),
                                Expanded(
                                  child: Text(
                                    promptTask?.promptText ?? "",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Section 2: Chart (Flexible section)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: chartHeight,
                child: Chart.from(
                  key: _chartKey,
                  recipe: recipe,
                  onInteraction: (p0, p1) {},
                ),
              ),

              // Section 3: Action buttons
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: actionHeight,
                child: showNextButton
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: ButtonWidget(
                            color: colors.primary,
                            btnContent: "Next",
                            onTap: () {
                              widget.onNextClick();
                            }),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: userActionContainer(),
                      ),
              ),
            ],
          );
        },
      ),
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
      case TaskType.clearTask:
        return Container();
    }
  }

  Widget mcqWidget() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    Task task = currentTask;
    if (task is! AddMcqTask) return const SizedBox.shrink();

    AddMcqTask mcqTask = task;
    int columns, rows;

    switch (mcqTask.arrangementType) {
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
          children: mcqTask.options.map((e) {
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

// This is needed for the Math.max function used above
class Math {
  static double max(double a, double b) {
    return a > b ? a : b;
  }
}
