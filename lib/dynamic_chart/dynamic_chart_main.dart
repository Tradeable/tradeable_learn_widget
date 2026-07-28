import 'package:fin_chart/models/enums/action_type.dart';
import 'package:fin_chart/models/enums/mcq_arrangment_type.dart';
import 'package:fin_chart/models/table_model.dart';
import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/tasks/add_remove_tools.task.dart';
import 'package:fin_chart/models/tasks/show_tools.task.dart';
import 'package:fin_chart/models/tasks/toggle_tool_visibility.task.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/indicators/pivot_point.dart';
import 'package:fin_chart/models/indicators/pe.dart';
import 'package:fin_chart/models/indicators/pb.dart';
import 'package:fin_chart/models/indicators/supertrend.dart';
import 'package:fin_chart/models/indicators/vwap.dart';
import 'package:fin_chart/models/indicators/ev_ebitda.dart';
import 'package:fin_chart/models/indicators/ev_sales.dart';
import 'package:fin_chart/models/indicators/scanner_indicator.dart';
import 'package:fin_chart/models/indicators/roc.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/sahi_tools_bar.dart';
import 'package:tradeable_learn_widget/dynamic_chart/insights_v2.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_table.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/dynamic_chart/insights_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/option_chain/column_visibility_editor.dart';
import 'package:tradeable_learn_widget/dynamic_chart/preview_screen.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_dialog_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/feedback_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/sidenav_manager.dart';
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
  List<ShowInsightsPageV2Task> v2insightsTasks = [];
  List<TableTask> tableTasks = [];
  List<Map<String, String>> tabs = [];
  int currentPageIndex = 0;
  List<finchart.OptionLeg> selectedLegs = [];
  Map<String, List<GlobalKey<CustomTableState>>> tableWidgetKeys = {};
  bool isSideNavVisible = false;
  Map<String, String?> sideNavSelectedDesc = {};
  String? expandedSideNavId;
  late SideNavController sideNavController;

  Map<String, GlobalKey<ChartState>> chartKeys = {};
  GlobalKey<ChartState>? _activeChartKey;
  ShowToolsTask? _currentShowToolsTask;
  LayerType? _selectedLayerType;
  List<Offset> drawPoints = [];
  Offset? startingPoint;
  // bool _isToolPanelOpen = false;
  // OpenToolPanelTask? _currentToolPanelTask;
  String? _activeChartId;
  int _activeChartStartOffset = 0;
  int _activeChartEndOffset = -1;
  final Map<String, bool> _hasPlottedFirstChunk = {};

  List<JourneyState> journeys = [];
  String? _activeJourneyId;
  String? courseVideoUrl;

  @override
  void initState() {
    recipe = widget.model.recipe;
    if (recipe.tasks.isNotEmpty) {
      currentTask = recipe.tasks.first;
      dd();
    }
    sideNavController = SideNavController();
    _activeChartKey = _chartKey;
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
        final chartKey =
            task.chartId != null ? chartKeys[task.chartId] : _activeChartKey;
        if (chartKey == null) {
          onTaskFinish();
          break;
        }
        final state = chartKey.currentState;
        if (state == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onTaskRun();
          });
          break;
        }

        int from = task.fromPoint;
        int till = task.tillPoint;

        final targetChartId = task.chartId ?? _activeChartId;
        if (targetChartId != null) {
          final chartTask = recipe.tasks
              .whereType<AddChartTabTask>()
              .where((t) => t.id == targetChartId)
              .firstOrNull;
          final startOffset = chartTask?.fromPoint ?? _activeChartStartOffset;
          final endOffset = chartTask?.tillPoint ?? _activeChartEndOffset;

          final isFirstChunk = _hasPlottedFirstChunk[targetChartId] != true;
          if (isFirstChunk) {
            from = startOffset;
          } else if (from < startOffset) {
            from = startOffset;
          }

          if (endOffset >= 0 && till > endOffset) {
            till = endOffset;
          }
        }

        from = from.clamp(0, recipe.data.length);
        till = till.clamp(from, recipe.data.length);
        if (till <= from) {
          onTaskFinish();
          break;
        }

        state
            .addDataWithAnimation(recipe.data.sublist(from, till),
                const Duration(milliseconds: 10))
            .then((_) {
          if (targetChartId != null) {
            _hasPlottedFirstChunk[targetChartId] = true;
          }
          onTaskFinish();
        });
        break;
      case TaskType.addIndicator:
        AddIndicatorTask task = currentTask as AddIndicatorTask;
        final targetChartKey =
            task.chartId != null ? chartKeys[task.chartId] : _activeChartKey;
        targetChartKey?.currentState?.addIndicator(task.indicator);
        onTaskFinish();
        break;
      case TaskType.addLayer:
        AddLayerTask task = currentTask as AddLayerTask;
        _activeChartKey?.currentState
            ?.addLayerAtRegion(task.regionId, task.layer);
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
        final chartKey = _chartKeyForCurrentTab();
        if (chartKey?.currentState != null) {
          chartKey?.currentState?.clearChart();
        }
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
      case TaskType.addChartTab:
        setState(() {
          final task = currentTask as AddChartTabTask;
          final chartKey = GlobalKey<ChartState>();
          chartKeys[task.id] = chartKey;
          _activeChartId = task.id;
          _activeChartStartOffset = task.fromPoint;
          _activeChartEndOffset = task.tillPoint;
          _hasPlottedFirstChunk[task.id] = false;
          _activeChartKey = chartKey;
        });
        onTaskFinish();
        break;
      case TaskType.addTab:
        {
          final task = currentTask as AddTabTask;

          final chartTask = recipe.tasks
              .whereType<AddChartTabTask>()
              .where((t) => t.id == task.taskId)
              .toList();

          if (chartTask.isNotEmpty) {
            int addedIndex = -1;
            setState(() {
              final existingIndex = tabs.indexWhere((tab) =>
                  tab["type"] == "chart" && tab["taskId"] == task.taskId);
              if (existingIndex == -1) {
                tabs.add({
                  "type": "chart",
                  "title": task.tabTitle,
                  "taskId": task.taskId,
                });
                addedIndex = tabs.length - 1;
              } else {
                addedIndex = existingIndex;
              }
            });
            _activeChartKey = chartKeys[task.taskId];
            if (addedIndex >= 0 && addedIndex != currentPageIndex) {
              navigateToPage(addedIndex).then((_) {
                onTaskFinish();
              });
            } else {
              onTaskFinish();
            }
          } else {
            int addedIndex = -1;
            setState(() {
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
                  addedIndex = tabs.length - 1;
                } else if (recipe.tasks.any(
                    (t) => t is ShowInsightsPageTask && t.id == task.taskId)) {
                  tabs.add({
                    "type": "insights",
                    "title": task.tabTitle,
                    "taskId": task.taskId,
                  });
                  addedIndex = tabs.length - 1;
                } else if (recipe.tasks
                    .any((t) => t is TableTask && t.id == task.taskId)) {
                  tabs.add({
                    "type": "table",
                    "title": task.tabTitle,
                    "taskId": task.taskId,
                  });
                  addedIndex = tabs.length - 1;
                } else if (recipe.tasks.any(
                    (t) => t is ShowPayOffGraphTask && t.id == task.taskId)) {
                  tabs.add({
                    "type": "payoff",
                    "title": task.tabTitle,
                    "taskId": task.taskId
                  });
                  addedIndex = tabs.length - 1;
                } else if (recipe.tasks.any((t) =>
                    t is ShowInsightsPageV2Task && t.id == task.taskId)) {
                  tabs.add({
                    "type": "insights_v2",
                    "title": task.tabTitle,
                    "taskId": task.taskId,
                  });
                  addedIndex = tabs.length - 1;
                }
              }
            });
            if (addedIndex >= 0 && addedIndex != currentPageIndex) {
              navigateToPage(addedIndex).then((_) {
                onTaskFinish();
              });
            } else {
              onTaskFinish();
            }
          }
        }
        break;
      case TaskType.removeTab:
        setState(() {
          final task = currentTask as RemoveTabTask;
          final removedTab = tabs.firstWhere(
            (tab) => tab["title"] == task.tabTitle,
            orElse: () => {},
          );
          if (removedTab["type"] == "chart" && removedTab["taskId"] != null) {
            chartKeys.remove(removedTab["taskId"]);
          }
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
          break;
        }
        final targetIndex = tabs.indexWhere(
          (tab) => tab["taskId"] == task.tabTaskID,
        );
        if (targetIndex == -1) {
          onTaskFinish();
          break;
        }
        final targetTab = tabs[targetIndex];
        if (targetTab["type"] == "chart") {
          final taskId = targetTab["taskId"];
          if (taskId != null && chartKeys.containsKey(taskId)) {
            _activeChartId = taskId;
            _activeChartKey = chartKeys[taskId];
            final chartTask = recipe.tasks
                .whereType<AddChartTabTask>()
                .firstWhere((t) => t.id == taskId,
                    orElse: () => AddChartTabTask(tabTitle: '', id: taskId));
            _activeChartStartOffset = chartTask.fromPoint;
            _activeChartEndOffset = chartTask.tillPoint;
          }
        }
        navigateToPage(targetIndex).then((_) {
          onTaskFinish();
        });
        break;
      case TaskType.popUpTask:
        final colors =
            TLW().themeData?.customColors ?? Theme.of(context).customColors;

        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((c) {
          showDialog(
              context: context,
              barrierColor:
                  colors.dynamicChartBlurBg.withAlpha((0.5 * 255).round()),
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
        final colors =
            TLW().themeData?.customColors ?? Theme.of(context).customColors;

        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((c) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              barrierColor:
                  colors.dynamicChartBlurBg.withAlpha((0.5 * 255).round()),
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
      case TaskType.showInsightsV2Page:
        ShowInsightsPageV2Task task = currentTask as ShowInsightsPageV2Task;
        v2insightsTasks.add(task);
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.showTools:
        final task = currentTask as ShowToolsTask;
        setState(() {
          _currentShowToolsTask = task;
        });
        onTaskFinish();
        break;
      case TaskType.toggleToolVisibility:
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.addRemoveTools:
        setState(() {});
        onTaskFinish();
        break;
      case TaskType.openToolPanel:
        // final task = currentTask as OpenToolPanelTask;
        setState(() {
          // _isToolPanelOpen = task.open;
          // _currentToolPanelTask = task;
        });
        onTaskFinish();
        break;
      case TaskType.startJourney:
        final task = currentTask as StartJourneyTask;
        setState(() {
          journeys.add(JourneyState(id: task.journeyId));
          _activeJourneyId = task.journeyId;
        });
        onTaskFinish();
        break;
      case TaskType.completeJourney:
        setState(() {
          if (_activeJourneyId != null) {
            final journey = journeys.firstWhere(
              (j) => j.id == _activeJourneyId,
              orElse: () => JourneyState(id: ''),
            );
            journey.completed = true;
          }
        });
        onTaskFinish();
        break;
      case TaskType.attachVideoToJourney:
        final task = currentTask as AttachVideoToJourneyTask;
        if (_activeJourneyId == null) {
          onTaskFinish();
          break;
        }
        setState(() {
          task.journeyId = _activeJourneyId!;
          final journey = journeys.firstWhere(
            (j) => j.id == _activeJourneyId,
            orElse: () => JourneyState(id: _activeJourneyId!),
          );
          journey.videoUrl = task.videoUrl;
        });
        onTaskFinish();
        break;
      case TaskType.hideVideoBtnInJourney:
        final task = currentTask as HideVideoBtnInJourneyTask;
        if (_activeJourneyId == null) {
          onTaskFinish();
          break;
        }
        setState(() {
          task.journeyId = _activeJourneyId!;
          final journey = journeys.firstWhere(
            (j) => j.id == _activeJourneyId,
            orElse: () => JourneyState(id: _activeJourneyId!),
          );
          journey.hideVideoBtn = true;
        });
        onTaskFinish();
        break;
      case TaskType.addCourseVideo:
        final task = currentTask as AddCourseVideoTask;
        setState(() {
          courseVideoUrl = task.videoUrl;
        });
        onTaskFinish();
        break;
    }
  }

  GlobalKey<ChartState>? _chartKeyForCurrentTab() {
    if (currentPageIndex < 0 || currentPageIndex >= tabs.length) {
      if (tabs.isNotEmpty && tabs.first["type"] == "chart") {
        return _activeChartKey;
      }
      return _chartKey;
    }
    final tab = tabs[currentPageIndex];
    if (tab["type"] != "chart") return _activeChartKey ?? _chartKey;
    final taskId = tab["taskId"];
    if (taskId != null && chartKeys.containsKey(taskId)) {
      return chartKeys[taskId];
    }
    return _activeChartKey ?? _chartKey;
  }

  void _onToolTap(String toolName) {
    final chartState = _chartKeyForCurrentTab()?.currentState;
    if (chartState == null) return;

    for (final indicatorType in IndicatorType.values) {
      if (indicatorType.name == toolName) {
        Indicator indicator;
        switch (indicatorType) {
          case IndicatorType.rsi:
            indicator = Rsi();
            break;
          case IndicatorType.macd:
            indicator = Macd();
            break;
          case IndicatorType.sma:
            indicator = Sma();
            break;
          case IndicatorType.ema:
            indicator = Ema();
            break;
          case IndicatorType.bollingerBand:
            indicator = BollingerBands();
            break;
          case IndicatorType.stochastic:
            indicator = Stochastic();
            break;
          case IndicatorType.atr:
            indicator = Atr();
            break;
          case IndicatorType.mfi:
            indicator = Mfi();
            break;
          case IndicatorType.adx:
            indicator = Adx();
            break;
          case IndicatorType.pivotPoint:
            indicator = PivotPoint();
            break;
          case IndicatorType.pe:
            indicator = Pe();
            break;
          case IndicatorType.pb:
            indicator = Pb();
            break;
          case IndicatorType.supertrend:
            indicator = Supertrend();
            break;
          case IndicatorType.vwap:
            indicator = Vwap();
            break;
          case IndicatorType.evEbitda:
            indicator = EvEbitda();
            break;
          case IndicatorType.evSales:
            indicator = EvSales();
            break;
          case IndicatorType.scanner:
            indicator = ScannerIndicator();
            break;
          case IndicatorType.roc:
            indicator = Roc();
            break;
        }
        chartState.addIndicator(indicator);
        return;
      }
    }

    for (final layerType in LayerType.values) {
      if (layerType.name == toolName) {
        setState(() {
          _selectedLayerType = layerType;
        });
        chartState.updateLayerGettingAddedState(layerType);
        return;
      }
    }
  }

  void _onClearTools() {
    final chartState = _chartKeyForCurrentTab()?.currentState;
    if (chartState == null) return;
    chartState.clearAllTools();
    setState(() {
      _selectedLayerType = null;
      drawPoints.clear();
      startingPoint = null;
    });
  }

  void _onInteraction(Offset tapDownPoint, Offset updatedPoint) {
    if (_selectedLayerType == null) return;

    drawPoints.add(tapDownPoint);
    startingPoint = updatedPoint;
    Layer? layer;
    switch (_selectedLayerType) {
      case LayerType.label:
        layer = Label.fromTool(
            pos: drawPoints.first,
            label: "Text",
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold));
        break;
      case LayerType.trendLine:
        if (drawPoints.length >= 2) {
          layer = TrendLine.fromTool(
              from: drawPoints.first,
              to: drawPoints.last,
              startPoint: startingPoint!);
        }
        break;
      case LayerType.horizontalLine:
        layer = HorizontalLine.fromTool(value: drawPoints.first.dy);
        break;
      case LayerType.horizontalBand:
        layer = HorizontalBand.fromTool(
            value: drawPoints.first.dy, allowedError: 70);
        break;
      case LayerType.rectArea:
        if (drawPoints.length >= 2) {
          layer = RectArea.fromTool(
              topLeft: drawPoints.first,
              bottomRight: drawPoints.last,
              dragStartPos: startingPoint!);
        }
        break;
      case LayerType.circularArea:
        layer = CircularArea.fromTool(point: drawPoints.first);
        break;
      case LayerType.arrow:
        if (drawPoints.length >= 2) {
          layer = Arrow.fromTool(
              from: drawPoints.first,
              to: drawPoints.last,
              startPoint: startingPoint!);
        }
        break;
      case LayerType.verticalLine:
        layer = VerticalLine.fromTool(pos: tapDownPoint.dx);
        break;
      case LayerType.parallelChannel:
        if (drawPoints.length >= 2) {
          layer = ParallelChannel.fromTool(
              topLeft: drawPoints.first,
              bottomRight: drawPoints.last,
              dragPoint: startingPoint!);
        }
        break;
      case LayerType.arrowTextPointer:
        layer = ArrowTextPointer.fromTool(pos: drawPoints.first, label: "");
        break;
      case null:
        break;
    }

    if (layer != null) {
      final chartState = _chartKeyForCurrentTab()?.currentState;
      if (chartState != null) {
        setState(() {
          _selectedLayerType = null;
          drawPoints.clear();
        });
        chartState.addLayerUsingTool(layer);
      }
    }
  }

  List<SahiToolsModel> _buildToolsList() {
    final List<String> allToolNames = [];
    for (final indicator in IndicatorType.values) {
      allToolNames.add(indicator.name);
    }
    for (final layer in LayerType.values) {
      allToolNames.add(layer.name);
    }

    final Map<String, bool> visibility = {};
    final Map<String, bool> enabled = {};

    final executedTasks = recipe.tasks.sublist(0, taskPointer);
    for (final t in executedTasks) {
      if (t is ShowToolsTask) {
        for (final tool in t.tools) {
          visibility[tool.title] = tool.isVisible;
          enabled[tool.title] = tool.isEnabled;
        }
      } else if (t is ToggleToolVisibilityTask) {
        visibility.addAll(t.visibility);
      } else if (t is AddRemoveToolsTask) {
        enabled.addAll(t.enabled);
      }
    }

    return allToolNames
        .where((name) => visibility[name] ?? false)
        .map((name) => SahiToolsModel(
              title: name,
              isVisible: true,
              isEnabled: enabled[name] ?? false,
            ))
        .toList();
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (tabs.isNotEmpty) renderTabs(),
              if (promptTask == null) Container() else renderPrompt(),
              if (_currentShowToolsTask != null)
                SahiToolsBar(
                  tools: _buildToolsList(),
                  onToolTap: _onToolTap,
                  trailing: GestureDetector(
                    onTap: _onClearTools,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0x80C9C4D3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete_outline,
                              size: 14, color: const Color(0xFF2D2D2D)),
                          const SizedBox(width: 4),
                          Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2D2D2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: tabs.isEmpty
                    ? const SizedBox.shrink()
                    : PageView.builder(
                        controller: controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final tab = tabs[index];
                          switch (tab["type"]) {
                            case "chart":
                              final chartTaskId = tab["taskId"];
                              final chartKey = chartTaskId != null &&
                                      chartKeys.containsKey(chartTaskId)
                                  ? chartKeys[chartTaskId]!
                                  : _chartKey;
                              return Container(
                                decoration: BoxDecoration(
                                    color: colors.cardBasicBackground,
                                    borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.all(16),
                                child: Chart.from(
                                    key: chartKey,
                                    recipe: recipe,
                                    onInteraction: _onInteraction),
                              );
                            case "option_chain":
                              if (_isOptionChainLoading) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                                  .whereType<
                                      ChooseCorrectOptionValueChainTask>()
                                  .firstWhere((t) => t.taskId == taskId);

                              final optionChainTask =
                                  optionChainTasks.firstWhere(
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
                                      builder: (context) =>
                                          ColumnVisibilityEditor(
                                        columns: optionChainTask.columns,
                                        onVisibilityChanged: (updatedColumns) {
                                          setState(() {
                                            optionChainTask.columns =
                                                updatedColumns;
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
                                      spotPriceDayDelta:
                                          payoffTask.spotPriceDayDelta,
                                      spotPriceDayDeltaPer:
                                          payoffTask.spotPriceDayDeltaPer,
                                      onExecute: () {},
                                      legs: selectedLegs
                                          .map((e) =>
                                              strategy.OptionLeg.fromJson(
                                                  e.toJson()))
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
                                          tables: [
                                            tableTask.tables.tables[tableIdx]
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );

                            case "insights_v2":
                              final taskId = tab["taskId"]!;
                              final v2insightsTask = recipe.tasks
                                  .whereType<ShowInsightsPageV2Task>()
                                  .firstWhere(
                                    (t) => t.id == taskId,
                                    orElse: () => v2insightsTasks.first,
                                  );
                              return InsightsV2Widget(task: v2insightsTask);
                            default:
                              return Container();
                          }
                        }),
              ),
              Container(
                  padding: const EdgeInsets.all(16),
                  child: userActionContainer()),
            ],
          ),
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
          color: colors.primaryButtonColor,
          btnContent: (currentTask as WaitTask).btnText,
          onTap: () => onTaskFinish(),
        );
      case TaskType.clearTask:
      case TaskType.addOptionChain:
      case TaskType.chooseCorrectOptionChainValue:
      case TaskType.highlightCorrectOptionChainValue:
      case TaskType.showPayOffGraph:
      case TaskType.addTab:
      case TaskType.addChartTab:
      case TaskType.removeTab:
      case TaskType.moveTab:
      case TaskType.popUpTask:
      case TaskType.showBottomSheet:
      case TaskType.showInsightsPage:
      case TaskType.chooseBucketRows:
      case TaskType.clearBucketRows:
      case TaskType.tableTask:
      case TaskType.highlightTableRow:
      case TaskType.showInsightsV2Page:
      case TaskType.showTools:
      case TaskType.toggleToolVisibility:
      case TaskType.addRemoveTools:
      case TaskType.openToolPanel:
      case TaskType.startJourney:
      case TaskType.completeJourney:
      case TaskType.attachVideoToJourney:
      case TaskType.hideVideoBtnInJourney:
      case TaskType.addCourseVideo:
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.dynamicChartInstructionBG,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
              child: SizedBox(
                  key: ValueKey(promptTask),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                        style: textStyles.mediumBold),
                                (promptTask!.hint ?? "").isNotEmpty
                                    ? TapTooltip(
                                        message: 'Hint!\n${promptTask!.hint}',
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colors.feedbackWidgetBG,
                                            ),
                                            child: SvgPicture.asset(
                                              "assets/instruction_hint.svg",
                                              package:
                                                  'tradeable_learn_widget/lib',
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const Spacer(),
                                const FeedbackWidget()
                              ],
                            ),
                            const SizedBox(height: 4),
                            MarkdownWidget(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                data: promptTask?.promptText ?? "")
                          ],
                        ),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }

  Widget renderTabs() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: colors.buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).round()),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...tabs.map((tab) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            final tabIndex = tabs.indexOf(tab);
                            navigateToPage(tabIndex);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: currentPageIndex == tabs.indexOf(tab)
                                    ? colors.dynamicChartActiveTabColor
                                    : colors.dynamicChartInactiveTabColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: colors.dynamicChartTabBorderColor)),
                            child: Text(
                              tab["title"] ?? "",
                              style: textStyles.smallNormal.copyWith(
                                color: currentPageIndex == tabs.indexOf(tab)
                                    ? colors.dynamicChartActiveTextColor
                                    : colors.dynamicChartInactiveTextColor,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
