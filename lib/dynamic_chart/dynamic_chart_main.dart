import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/mcq_arrangment_type.dart';
import 'package:fin_chart/models/table_model.dart';
import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/choose_bucket_rows_task.dart';
import 'package:fin_chart/models/tasks/choose_correct_option_chain_task.dart';
import 'package:fin_chart/models/tasks/clear_bucket_rows_task.dart';
import 'package:fin_chart/models/tasks/highlight_correct_option_chain_value_task.dart';
import 'package:fin_chart/models/tasks/highlight_table_row_task.dart';
import 'package:fin_chart/models/tasks/show_bottom_sheet.task.dart';
import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/tasks/wait.task.dart';
import 'package:fin_chart/fin_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_table.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/dynamic_chart/insights_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/option_chain/column_visibility_editor.dart';
import 'package:tradeable_learn_widget/dynamic_chart/preview_screen.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_dialog_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/feedback_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/tool_tip_widget.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:fin_chart/option_chain/models/option_leg.dart' as finchart;
import 'package:tradeable_learn_widget/option_strategy/models/option_strategy_leg.model.dart'
    as strategy;

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
  Map<String, GlobalKey<PreviewScreenState>> previewScreenKeys = {};
  late Recipe recipe;
  bool _isOptionChainLoading = false;

  int taskPointer = 0;
  late Task currentTask;

  AddPromptTask? promptTask;
  bool showNextButton = false;
  PageController controller = PageController();
  AddOptionChainTask? correctOptionChainTask;

  List<AddOptionChainTask> optionChainTasks = [];
  List<ShowPayOffGraphTask> payoffGraphTasks = [];
  List<ShowInsightsPageTask> insightsTasks = [];
  List<TableTask> tableTasks = [];
  List<Map<String, String>> tabs = [];
  int currentPageIndex = 0;
  List<finchart.OptionLeg> selectedLegs = [];
  Map<String, List<GlobalKey<CustomTableState>>> tableWidgetKeys = {};

  @override
  void initState() {
    recipe = widget.model.recipe;
    if (recipe.tasks.isNotEmpty) {
      currentTask = recipe.tasks.first;
      dd();
    }
    tabs.add({"type": "chart", "title": "Chart"});

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
        if (!optionChainTasks
            .any((t) => t.optionChainId == task.optionChainId)) {
          optionChainTasks.add(task);
        }
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.chooseCorrectOptionChainValue:
        onTaskFinish();
        setState(() {});
        break;
      case TaskType.highlightCorrectOptionChainValue:
        HighlightCorrectOptionChainValueTask task =
            currentTask as HighlightCorrectOptionChainValueTask;
        final taskId = task.optionChainId;
        final previewKey = previewScreenKeys[taskId];
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          if ((task.bucketRows ?? []).isNotEmpty) {
            previewKey?.currentState
                ?.chooseBucketRows(task.bucketRows!.cast<finchart.OptionLeg>());
          } else {
            for (int i in task.correctRowIndex) {
              previewKey?.currentState?.chooseRow(i);
            }
          }
          onTaskFinish();
        });
        setState(() {});
        break;
      case TaskType.showPayOffGraph:
        ShowPayOffGraphTask task = currentTask as ShowPayOffGraphTask;
        payoffGraphTasks.add(task);
        onTaskFinish();
        break;
      case TaskType.addTab:
        setState(() {
          final task = currentTask as AddTabTask;
          previewScreenKeys[task.taskId] = GlobalKey<PreviewScreenState>();

          if (!tabs.any((tab) => tab["taskId"] == task.taskId)) {
            if (recipe.tasks.any((t) =>
                t is ChooseCorrectOptionValueChainTask &&
                t.taskId == task.taskId)) {
              tabs.add({
                "type": "option_chain",
                "title": task.tabTitle,
                "taskId": task.taskId
              });
            } else if (recipe.tasks
                .any((t) => t is ShowInsightsPageTask && t.id == task.taskId)) {
              tabs.add({
                "type": "insights",
                "title": task.tabTitle,
                "taskId": task.taskId,
              });
            } else if (recipe.tasks
                .any((t) => t is TableTask && t.id == task.taskId)) {
              tabs.add({
                "type": "table",
                "title": task.tabTitle,
                "taskId": task.taskId,
              });
            } else if (recipe.tasks.any((t) => t is ShowPayOffGraphTask)) {
              tabs.add({
                "type": "payoff",
                "title": task.tabTitle,
                "taskId": task.taskId
              });
            }
          }
        });
        onTaskFinish();
        break;
      case TaskType.removeTab:
        setState(() {
          final task = currentTask as RemoveTabTask;
          tabs.removeWhere((tab) => tab["title"] == task.tabTitle);
        });
        onTaskFinish();
        break;
      case TaskType.moveTab:
        MoveTabTask task = currentTask as MoveTabTask;
        if (task.tabTaskID == "chart") {
          navigateToPage(0).then((_) {
            onTaskFinish();
          });
          return;
        }
        final addTabTasks = recipe.tasks.whereType<AddTabTask>().toList();
        if (addTabTasks.isEmpty) {
          onTaskFinish();
          return;
        }
        final targetTabTask =
            addTabTasks.firstWhere((t) => t.taskId == task.tabTaskID);
        final targetTab = tabs.firstWhere(
          (tab) => tab["title"] == targetTabTask.tabTitle,
          orElse: () => tabs.first,
        );
        final targetTabIndex = tabs.indexOf(targetTab);

        navigateToPage(targetTabIndex).then((_) {
          onTaskFinish();
        });
        break;
      case TaskType.popUpTask:
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((c) {
          showDialog(
              context: context,
              builder: (context) {
                ShowPopupTask task = currentTask as ShowPopupTask;
                return CustomDialogWidget(
                    task: task,
                    moveNext: () {
                      Navigator.of(context).pop();
                    });
              }).then((val) {
            onTaskFinish();
          });
        });
        setState(() {});
        break;
      case TaskType.showBottomSheet:
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((c) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                ShowBottomSheetTask task = currentTask as ShowBottomSheetTask;
                return CustomBottomSheetWidget(
                    task: task,
                    moveNext: () => Navigator.of(context).pop(),
                    isCorrect: true);
              }).then((val) {
            onTaskFinish();
          });
        });
        setState(() {});
        break;
      case TaskType.showInsightsPage:
        ShowInsightsPageTask task = currentTask as ShowInsightsPageTask;
        insightsTasks.add(task);
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.chooseBucketRows:
        ChooseBucketRowsTask task = currentTask as ChooseBucketRowsTask;
        final previewKey = previewScreenKeys[task.optionChainId];
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          if (previewKey != null) {
            if (task.bucketRows != null && task.bucketRows!.isNotEmpty) {
              previewKey.currentState?.setBuySellSelections(
                  task.bucketRows!.cast<finchart.OptionLeg>());
            }
          }
        });
        selectedLegs = (task.bucketRows ?? []).cast<finchart.OptionLeg>();
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.clearBucketRows:
        ClearBucketRowsTask task = currentTask as ClearBucketRowsTask;
        final previewKey = previewScreenKeys[task.optionChainId];
        if (previewKey != null) {
          previewKey.currentState?.clearBucketSelections();
        }
        selectedLegs.clear();
        onTaskFinish();
        break;
      case TaskType.tableTask:
        TableTask task = currentTask as TableTask;
        tableTasks.add(task);
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.highlightTableRow:
        final task = currentTask as HighlightTableRowTask;
        final tableTask = recipe.tasks
            .whereType<TableTask>()
            .firstWhere((t) => t.id == task.tableTaskId);
        final keys = tableWidgetKeys[task.tableTaskId];
        if (keys != null) {
          for (int i = 0; i < tableTask.tables.tables.length; i++) {
            final key = keys[i];
            final selected = (task.selectedRows[i] != null)
                ? Set<int>.from(task.selectedRows[i]!)
                : <int>{};
            if (key.currentState != null) {
              key.currentState!.setSelectedRows(selected);
            }
          }
        }
        setState(() {});
        onTaskFinish();
        break;
    }
  }

  Future<void> navigateToPage(int pageIndex) async {
    setState(() {
      currentPageIndex = pageIndex;
      if (tabs[pageIndex]["type"] == "option_chain") {
        _isOptionChainLoading = true;
      }
    });

    await controller.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    if (tabs[pageIndex]["type"] == "option_chain") {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _isOptionChainLoading = false;
        });
      }
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

  void _handleBuySellSelection(finchart.OptionLeg? optionLeg) {
    if (optionLeg != null) {
      selectedLegs = [];
      setState(() {
        selectedLegs.add(optionLeg);
      });
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
          if (promptTask == null) Container() else renderPrompt(),
          Expanded(
            child: PageView.builder(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final tab = tabs[index];
                  switch (tab["type"]) {
                    case "chart":
                      return Chart.from(
                          key: _chartKey,
                          recipe: recipe,
                          onInteraction: (p0, p1) {});
                    case "option_chain":
                      if (_isOptionChainLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    colors.primary),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Loading option chain...",
                                style: textStyles.mediumNormal.copyWith(
                                  color: colors.textColorSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final taskId = tab["taskId"]!;
                      final chooseTask = recipe.tasks
                          .whereType<ChooseCorrectOptionValueChainTask>()
                          .firstWhere((t) => t.taskId == taskId);

                      final optionChainTask = optionChainTasks.firstWhere(
                        (t) => t.optionChainId == chooseTask.taskId,
                        orElse: () => optionChainTasks.first,
                      );

                      return PreviewScreen.from(
                          key: previewScreenKeys[taskId] ?? GlobalKey(),
                          task: optionChainTask,
                          onViewChartClicked: () {
                            navigateToPage(0);
                          },
                          onSettingsClicked: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ColumnVisibilityEditor(
                                columns: optionChainTask.columns,
                                onVisibilityChanged: (updatedColumns) {
                                  setState(() {
                                    optionChainTask.columns = updatedColumns;
                                  });
                                },
                              ),
                            );
                          },
                          onBuySellSelected: _handleBuySellSelection,
                          isEditorMode: false);
                    case "payoff":
                      final taskId = tab["taskId"]!;
                      final payoffTask = payoffGraphTasks.firstWhere(
                        (t) => t.id == taskId,
                        orElse: () => payoffGraphTasks.first,
                      );
                      return selectedLegs.isEmpty
                          ? Center(
                              child: Text(
                                "Select buy/sell positions in the option chain to view payoff",
                                style: textStyles.mediumNormal.copyWith(
                                  color: colors.textColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : OptionStrategyContainer(
                              spotPrice: payoffTask.spotPrice,
                              spotPriceDayDelta: payoffTask.spotPriceDayDelta,
                              spotPriceDayDeltaPer:
                                  payoffTask.spotPriceDayDeltaPer,
                              onExecute: () {},
                              legs: selectedLegs
                                  .map((e) =>
                                      strategy.OptionLeg.fromJson(e.toJson()))
                                  .toList(),
                            );
                    case "insights":
                      final taskId = tab["taskId"]!;
                      final insightsTask = recipe.tasks
                          .whereType<ShowInsightsPageTask>()
                          .firstWhere(
                            (t) => t.id == taskId,
                            orElse: () => insightsTasks.first,
                          );
                      return InsightsWidget(insightsTask: insightsTask);
                    case "table":
                      final taskId = tab["taskId"]!;
                      final tableTask = recipe.tasks
                          .whereType<TableTask>()
                          .firstWhere((t) => t.id == taskId);
                      if (tableWidgetKeys[taskId] == null ||
                          tableWidgetKeys[taskId]!.length !=
                              tableTask.tables.tables.length) {
                        tableWidgetKeys[taskId] = List.generate(
                          tableTask.tables.tables.length,
                          (_) => GlobalKey<CustomTableState>(),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            tableTask.tables.tables.length,
                            (tableIdx) => CustomTable.from(
                              key: tableWidgetKeys[taskId]![tableIdx],
                              tableTask: TableTask(
                                tables: TablesModel(
                                  tables: [tableTask.tables.tables[tableIdx]],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    default:
                      return Container();
                  }
                }),
          ),
          Container(
              padding: const EdgeInsets.all(16), child: userActionContainer()),
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
      case TaskType.showPayOffGraph:
      case TaskType.addTab:
      case TaskType.removeTab:
      case TaskType.moveTab:
      case TaskType.popUpTask:
      case TaskType.showBottomSheet:
      case TaskType.showInsightsPage:
      case TaskType.chooseBucketRows:
      case TaskType.clearBucketRows:
      case TaskType.tableTask:
      case TaskType.highlightTableRow:
        return Container();
    }
  }

  Widget mcqWidget() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    Task task = currentTask;
    if (task is! AddMcqTask) return const SizedBox.shrink();

    AddMcqTask mcqTask = task;
    int columns;

    switch (mcqTask.arrangementType) {
      case MCQArrangementType.grid1x2:
        columns = 2;
        break;
      case MCQArrangementType.grid2x2:
        columns = 2;
        break;
      case MCQArrangementType.grid2x3:
        columns = 3;
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

  Widget renderPrompt() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.cardColorSecondary,
            borderRadius: (promptTask!.hint ?? "").isNotEmpty
                ? const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))
                : const BorderRadius.all(Radius.circular(20)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.buttonColor,
                    border: Border.all(color: colors.cardColorSecondary),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      promptTask != null && promptTask!.isExplanation
                          ? Row(
                              children: [
                                Text("Take Away", style: textStyles.smallBold),
                                const SizedBox(width: 6),
                              ],
                            )
                          : Text("Instruction",
                              style: textStyles.smallNormal
                                  .copyWith(color: colors.textColorSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        promptTask?.promptText ?? "",
                        style: textStyles.smallNormal,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...tabs.map((tab) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            final tabIndex = tabs.indexOf(tab);
                                            navigateToPage(tabIndex);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                                color: currentPageIndex ==
                                                        tabs.indexOf(tab)
                                                    ? colors.borderColorPrimary
                                                    : colors
                                                        .cardBasicBackground,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                    color: colors
                                                        .borderColorSecondary)),
                                            child: Text(
                                              tab["title"] ?? "",
                                              style: textStyles.smallNormal
                                                  .copyWith(
                                                color: currentPageIndex ==
                                                        tabs.indexOf(tab)
                                                    ? colors.cardColorPrimary
                                                    : colors.axisColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const FeedbackWidget()
                        ],
                      ),
                    ],
                  ))),
        ),
        (promptTask!.hint ?? "").isNotEmpty
            ? TapTooltip(
                message: 'Hint!\n${promptTask!.hint}',
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.cardColorSecondary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.cardBasicBackground,
                    ),
                    child: Image.asset(
                      "assets/prompt_hint_icon.png",
                      package: 'tradeable_learn_widget/lib',
                      height: 20,
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
