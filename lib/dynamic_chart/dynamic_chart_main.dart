import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/mcq_arrangment_type.dart';
import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/choose_correct_option_chain_task.dart';
import 'package:fin_chart/models/tasks/highlight_correct_option_chain_value_task.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/tasks/wait.task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/dynamic_chart/option_chain/column_visibility_editor.dart';
import 'package:tradeable_learn_widget/dynamic_chart/preview_screen.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/feedback_widget.dart';
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
  final GlobalKey<PreviewScreenState> _previewScreenKey = GlobalKey();
  late Recipe recipe;
  final List<Map<String, dynamic>> pages = [
    {
      'title': 'Chart',
      'index': 0,
    },
    {
      'title': 'Option Chain',
      'index': 1,
    },
  ];

  int taskPointer = 0;
  late Task currentTask;

  AddPromptTask? promptTask;
  bool showNextButton = false;
  bool switchToOptionChain = false;
  PageController controller = PageController();
  bool optionChainButtonVisibility = false;
  List<AddOptionChainTask> optionChainTasks = [];
  AddOptionChainTask? correctOptionChainTask;

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
      case TaskType.addOptionChain:
        AddOptionChainTask task = currentTask as AddOptionChainTask;

        optionChainButtonVisibility = true;
        optionChainTasks.add(task);
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.chooseCorrectOptionChainValue:
        ChooseCorrectOptionValueChainTask task =
            currentTask as ChooseCorrectOptionValueChainTask;
        correctOptionChainTask =
            optionChainTasks.firstWhere((e) => e.optionChainId == task.taskId);
        controller
            .animateToPage(1,
                duration: const Duration(seconds: 1), curve: Curves.easeIn)
            .then((val) {
          onTaskFinish();
        });
        switchToOptionChain = true;
        setState(() {});
        break;
      case TaskType.highlightCorrectOptionChainValue:
        HighlightCorrectOptionChainValueTask task =
            currentTask as HighlightCorrectOptionChainValueTask;
        if ((task.bucketRows ?? []).isNotEmpty) {
          _previewScreenKey.currentState?.chooseBucketRows(task.bucketRows!);
        } else {
          for (int i in task.correctRowIndex) {
            _previewScreenKey.currentState?.chooseRow(i);
          }
        }
        onTaskFinish();
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

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (promptTask == null)
            Container()
          else
            Container(
              margin: const EdgeInsets.all(10),
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
                        mainAxisSize: MainAxisSize.min,
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
                          const SizedBox(height: 4),
                          Text(
                            promptTask?.promptText ?? "",
                            style: textStyles.smallNormal,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ...pages.map((page) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          switchToOptionChain =
                                              page['index'] == 1;
                                          controller.animateToPage(
                                              page['index'],
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: (page['index'] == 0 &&
                                                      !switchToOptionChain) ||
                                                  (page['index'] == 1 &&
                                                      switchToOptionChain)
                                              ? colors.primary
                                              : colors.cardColorPrimary,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          page['title'],
                                          style:
                                              textStyles.smallNormal.copyWith(
                                            color: (page['index'] == 0 &&
                                                        !switchToOptionChain) ||
                                                    (page['index'] == 1 &&
                                                        switchToOptionChain)
                                                ? colors.cardColorPrimary
                                                : colors.textColorSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              const Spacer(),
                              const FeedbackWidget()
                            ],
                          ),
                        ],
                      ))),
            ),
          Expanded(
            child: PageView.builder(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Chart.from(
                        key: _chartKey,
                        recipe: recipe,
                        onInteraction: (p0, p1) {});
                  } else {
                    return PreviewScreen.from(
                        key: _previewScreenKey,
                        task: correctOptionChainTask!,
                        onViewChartClicked: () {
                          setState(() {
                            switchToOptionChain = !switchToOptionChain;
                            controller.animateToPage(
                                switchToOptionChain ? 1 : 0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn);
                          });
                        },
                        onSettingsClicked: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => ColumnVisibilityEditor(
                              columns: correctOptionChainTask!.columns,
                              onVisibilityChanged: (updatedColumns) {
                                setState(() {
                                  correctOptionChainTask!.columns =
                                      updatedColumns;
                                });
                              },
                            ),
                          );
                        },
                        isEditorMode: false);
                  }
                }),
          ),
          Container(
              padding: const EdgeInsets.all(20), child: userActionContainer()),
        ],
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
      case TaskType.addOptionChain:
      case TaskType.chooseCorrectOptionChainValue:
      case TaskType.highlightCorrectOptionChainValue:
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

    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 5,
        ),
        itemCount: mcqTask.options.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 80,
            child: InkWell(
              onTap: () => onTaskFinish(),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colors.buttonColor,
                  border: Border.all(color: colors.cardColorSecondary),
                ),
                child: Center(
                  child: Text(mcqTask.options[index]),
                ),
              ),
            ),
          );
        });
  }
}
