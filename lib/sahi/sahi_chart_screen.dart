import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/models/enums/task_type.dart';
import 'package:fin_chart/models/enums/mcq_arrangment_type.dart';
import 'package:fin_chart/models/recipe.dart';
import 'package:fin_chart/models/tasks/add_data.task.dart';
import 'package:fin_chart/models/tasks/add_indicator.task.dart';
import 'package:fin_chart/models/tasks/add_layer.task.dart';
import 'package:fin_chart/models/tasks/add_option_chain.task.dart';
import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:fin_chart/models/tasks/add_remove_tools.task.dart';
import 'package:fin_chart/models/tasks/show_tools.task.dart';
import 'package:fin_chart/models/tasks/toggle_tool_visibility.task.dart';
import 'package:fin_chart/models/tasks/task.dart';
import 'package:fin_chart/models/tasks/wait.task.dart';
import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/indicators/supertrend.dart';
import 'package:fin_chart/models/indicators/vwap.dart';
import 'package:fin_chart/models/indicators/roc.dart';
import 'package:fin_chart/models/indicators/pe.dart';
import 'package:fin_chart/models/indicators/pb.dart';
import 'package:fin_chart/models/indicators/pivot_point.dart';
import 'package:fin_chart/models/indicators/scanner_indicator.dart';
import 'package:fin_chart/models/indicators/ev_ebitda.dart';
import 'package:fin_chart/models/indicators/ev_sales.dart';
import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/table_model.dart';
import 'package:fin_chart/models/tasks/choose_bucket_rows_task.dart';
import 'package:fin_chart/models/tasks/choose_correct_option_chain_task.dart';
import 'package:fin_chart/models/tasks/clear_bucket_rows_task.dart';
import 'package:fin_chart/models/tasks/highlight_correct_option_chain_value_task.dart';
import 'package:fin_chart/models/tasks/highlight_table_row_task.dart';
import 'package:fin_chart/models/tasks/show_bottom_sheet.task.dart';
import 'package:fin_chart/models/tasks/show_insights_page.task.dart';
import 'package:fin_chart/models/tasks/table_task.dart';
import 'package:fin_chart/option_chain/models/option_leg.dart' as finchart;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_dialog_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_table.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/feedback_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/sahi_tools_bar.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/tool_tip_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/insights_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/insights_v2.dart';
import 'package:tradeable_learn_widget/dynamic_chart/preview_screen.dart';
import 'package:tradeable_learn_widget/dynamic_chart/option_chain/column_visibility_editor.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_container.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_top_bar.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/option_strategy/models/option_strategy_leg.model.dart'
    as strategy;

class SahiChartScreen extends StatefulWidget {
  final DynamicChartModel model;

  const SahiChartScreen({super.key, required this.model});

  @override
  State<SahiChartScreen> createState() => _SahiChartScreenState();
}

class _SahiChartScreenState extends State<SahiChartScreen> {
  late Recipe recipe;

  // Task execution
  int _taskPointer = 0;
  late Task _currentTask;
  AddPromptTask? _promptTask;

  // Tabs & pages
  PageController _pageController = PageController();
  List<Map<String, String>> _tabs = [];
  int _currentPageIndex = 0;

  // Chart keys
  Map<String, GlobalKey<ChartState>> _chartKeys = {};
  GlobalKey<ChartState> _chartKey = GlobalKey();
  GlobalKey<ChartState>? _activeChartKey;
  String? _activeChartId;
  int _activeChartStartOffset = 0;
  int _activeChartEndOffset = -1;
  final Map<String, bool> _hasPlottedFirstChunk = {};

  // Option chain
  Map<String, GlobalKey<PreviewScreenState>> _previewScreenKeys = {};
  List<finchart.OptionLeg> _selectedLegs = [];
  List<AddOptionChainTask> _optionChainTasks = [];
  bool _isOptionChainLoading = false;

  // Other content
  List<ShowPayOffGraphTask> _payoffGraphTasks = [];
  List<ShowInsightsPageTask> _insightsTasks = [];
  List<ShowInsightsPageV2Task> _v2insightsTasks = [];
  List<TableTask> _tableTasks = [];
  Map<String, List<GlobalKey<CustomTableState>>> _tableWidgetKeys = {};

  // Tools
  ShowToolsTask? _currentShowToolsTask;
  LayerType? _selectedLayerType;
  List<Offset> _drawPoints = [];
  Offset? _startingPoint;

  // Journeys
  List<_JourneyItem> _journeyItems = [];
  List<JourneyState> _journeys = [];
  String? _activeJourneyId;

  @override
  void initState() {
    super.initState();
    recipe = widget.model.recipe;
    _extractJourneys();

    if (recipe.tasks.isNotEmpty) {
      _currentTask = recipe.tasks.first;
      _runAfterDelay();
    }
    _activeChartKey = _chartKey;
  }

  void _extractJourneys() {
    final startTasks = recipe.tasks.whereType<StartJourneyTask>().toList();
    _journeyItems =
        startTasks.map((t) => _JourneyItem(id: t.journeyId)).toList();
  }

  void _runAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _onTaskRun();
  }

  // ─── Task execution (adapted from DynamicChartWidget) ───

  void _onTaskRun() {
    switch (_currentTask.taskType) {
      case TaskType.addData:
        _handleAddData();
        break;
      case TaskType.addIndicator:
        _handleAddIndicator();
        break;
      case TaskType.addLayer:
        _handleAddLayer();
        break;
      case TaskType.addPrompt:
        _handleAddPrompt();
        break;
      case TaskType.waitTask:
        setState(() {});
        break;
      case TaskType.addMcq:
        setState(() {});
        break;
      case TaskType.clearTask:
        _handleClearTask();
        break;
      case TaskType.addOptionChain:
        _handleAddOptionChain();
        break;
      case TaskType.chooseCorrectOptionChainValue:
        _onTaskFinish();
        setState(() {});
        break;
      case TaskType.highlightCorrectOptionChainValue:
        _handleHighlightOptionChain();
        break;
      case TaskType.showPayOffGraph:
        _handleShowPayoff();
        break;
      case TaskType.addChartTab:
        _handleAddChartTab();
        break;
      case TaskType.addTab:
        _handleAddTab();
        break;
      case TaskType.removeTab:
        _handleRemoveTab();
        break;
      case TaskType.moveTab:
        _handleMoveTab();
        break;
      case TaskType.popUpTask:
        _handlePopup();
        break;
      case TaskType.showBottomSheet:
        _handleBottomSheet();
        break;
      case TaskType.showInsightsPage:
        _handleShowInsights();
        break;
      case TaskType.chooseBucketRows:
        _handleChooseBucketRows();
        break;
      case TaskType.clearBucketRows:
        _handleClearBucketRows();
        break;
      case TaskType.tableTask:
        _handleTableTask();
        break;
      case TaskType.highlightTableRow:
        _handleHighlightTableRow();
        break;
      case TaskType.showInsightsV2Page:
        _handleShowInsightsV2();
        break;
      case TaskType.showTools:
        _handleShowTools();
        break;
      case TaskType.toggleToolVisibility:
        setState(() {});
        _onTaskFinish();
        break;
      case TaskType.addRemoveTools:
        setState(() {});
        _onTaskFinish();
        break;
      case TaskType.openToolPanel:
        setState(() {});
        _onTaskFinish();
        break;
      case TaskType.startJourney:
        _handleStartJourney();
        break;
      case TaskType.completeJourney:
        _handleCompleteJourney();
        break;
      case TaskType.attachVideoToJourney:
      case TaskType.hideVideoBtnInJourney:
      case TaskType.addCourseVideo:
        _onTaskFinish();
        break;
    }
  }

  void _handleAddData() {
    final task = _currentTask as AddDataTask;
    final key =
        task.chartId != null ? _chartKeys[task.chartId] : _activeChartKey;
    if (key == null) {
      _onTaskFinish();
      return;
    }
    final state = key.currentState;
    if (state == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onTaskRun());
      return;
    }

    int from = task.fromPoint;
    int till = task.tillPoint;

    final targetId = task.chartId ?? _activeChartId;
    if (targetId != null) {
      final chartTask = recipe.tasks
          .whereType<AddChartTabTask>()
          .where((t) => t.id == targetId)
          .firstOrNull;
      final start = chartTask?.fromPoint ?? _activeChartStartOffset;
      final end = chartTask?.tillPoint ?? _activeChartEndOffset;

      if (_hasPlottedFirstChunk[targetId] != true) {
        from = start;
      } else if (from < start) {
        from = start;
      }
      if (end >= 0 && till > end) till = end;
    }

    from = from.clamp(0, recipe.data.length);
    till = till.clamp(from, recipe.data.length);
    if (till <= from) {
      _onTaskFinish();
      return;
    }

    state
        .addDataWithAnimation(
            recipe.data.sublist(from, till), const Duration(milliseconds: 10))
        .then((_) {
      if (targetId != null) _hasPlottedFirstChunk[targetId] = true;
      _onTaskFinish();
    });
  }

  void _handleAddIndicator() {
    final task = _currentTask as AddIndicatorTask;
    final key =
        task.chartId != null ? _chartKeys[task.chartId] : _activeChartKey;
    key?.currentState?.addIndicator(task.indicator);
    _onTaskFinish();
  }

  void _handleAddLayer() {
    final task = _currentTask as AddLayerTask;
    _activeChartKey?.currentState?.addLayerAtRegion(task.regionId, task.layer);
    _onTaskFinish();
  }

  void _handleAddPrompt() {
    setState(() {
      _promptTask = _currentTask as AddPromptTask;
    });
    _onTaskFinish();
  }

  void _handleClearTask() {
    final key = _chartKeyForCurrentTab();
    key?.currentState?.clearChart();
    _onTaskFinish();
  }

  void _handleAddOptionChain() {
    final task = _currentTask as AddOptionChainTask;
    if (!_optionChainTasks.any((t) => t.optionChainId == task.optionChainId)) {
      _optionChainTasks.add(task);
    }
    setState(() {});
    _onTaskFinish();
  }

  void _handleHighlightOptionChain() {
    final task = _currentTask as HighlightCorrectOptionChainValueTask;
    final key = _previewScreenKeys[task.optionChainId];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if ((task.bucketRows ?? []).isNotEmpty) {
        key?.currentState
            ?.chooseBucketRows(task.bucketRows!.cast<finchart.OptionLeg>());
      } else {
        for (int i in task.correctRowIndex) {
          key?.currentState?.chooseRow(i);
        }
      }
      _onTaskFinish();
    });
    setState(() {});
  }

  void _handleShowPayoff() {
    _payoffGraphTasks.add(_currentTask as ShowPayOffGraphTask);
    _onTaskFinish();
  }

  void _handleAddChartTab() {
    setState(() {
      final task = _currentTask as AddChartTabTask;
      final key = GlobalKey<ChartState>();
      _chartKeys[task.id] = key;
      _activeChartId = task.id;
      _activeChartStartOffset = task.fromPoint;
      _activeChartEndOffset = task.tillPoint;
      _hasPlottedFirstChunk[task.id] = false;
      _activeChartKey = key;
    });
    _onTaskFinish();
  }

  void _handleAddTab() {
    final task = _currentTask as AddTabTask;

    final chartTasks = recipe.tasks
        .whereType<AddChartTabTask>()
        .where((t) => t.id == task.taskId)
        .toList();

    if (chartTasks.isNotEmpty) {
      int addedIndex = -1;
      setState(() {
        final existingIndex = _tabs.indexWhere(
            (tab) => tab["type"] == "chart" && tab["taskId"] == task.taskId);
        if (existingIndex == -1) {
          _tabs.add({
            "type": "chart",
            "title": task.tabTitle,
            "taskId": task.taskId,
          });
          addedIndex = _tabs.length - 1;
        } else {
          addedIndex = existingIndex;
        }
      });
      _activeChartKey = _chartKeys[task.taskId];
      if (addedIndex >= 0 && addedIndex != _currentPageIndex) {
        _navigateToPage(addedIndex).then((_) => _onTaskFinish());
      } else {
        _onTaskFinish();
      }
    } else {
      int addedIndex = -1;
      setState(() {
        _previewScreenKeys[task.taskId] = GlobalKey<PreviewScreenState>();
        if (!_tabs.any((tab) => tab["taskId"] == task.taskId)) {
          if (recipe.tasks.any((t) =>
              t is ChooseCorrectOptionValueChainTask &&
              t.taskId == task.taskId)) {
            _tabs.add({
              "type": "option_chain",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = _tabs.length - 1;
          } else if (recipe.tasks
              .any((t) => t is ShowInsightsPageTask && t.id == task.taskId)) {
            _tabs.add({
              "type": "insights",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = _tabs.length - 1;
          } else if (recipe.tasks
              .any((t) => t is TableTask && t.id == task.taskId)) {
            _tabs.add({
              "type": "table",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = _tabs.length - 1;
          } else if (recipe.tasks
              .any((t) => t is ShowPayOffGraphTask && t.id == task.taskId)) {
            _tabs.add({
              "type": "payoff",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = _tabs.length - 1;
          } else if (recipe.tasks
              .any((t) => t is ShowInsightsPageV2Task && t.id == task.taskId)) {
            _tabs.add({
              "type": "insights_v2",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = _tabs.length - 1;
          }
        }
      });
      if (addedIndex >= 0 && addedIndex != _currentPageIndex) {
        _navigateToPage(addedIndex).then((_) => _onTaskFinish());
      } else {
        _onTaskFinish();
      }
    }
  }

  void _handleRemoveTab() {
    setState(() {
      final task = _currentTask as RemoveTabTask;
      final removed = _tabs.firstWhere(
        (tab) => tab["title"] == task.tabTitle,
        orElse: () => {},
      );
      if (removed["type"] == "chart" && removed["taskId"] != null) {
        _chartKeys.remove(removed["taskId"]);
      }
      _tabs.removeWhere((tab) => tab["title"] == task.tabTitle);
    });
    _onTaskFinish();
  }

  void _handleMoveTab() {
    final task = _currentTask as MoveTabTask;
    if (task.tabTaskID == "chart") {
      _navigateToPage(0).then((_) => _onTaskFinish());
      return;
    }
    final targetIndex = _tabs.indexWhere(
      (tab) => tab["taskId"] == task.tabTaskID,
    );
    if (targetIndex == -1) {
      _onTaskFinish();
      return;
    }
    final targetTab = _tabs[targetIndex];
    if (targetTab["type"] == "chart") {
      final taskId = targetTab["taskId"];
      if (taskId != null && _chartKeys.containsKey(taskId)) {
        _activeChartId = taskId;
        _activeChartKey = _chartKeys[taskId];
        final chartTask = recipe.tasks.whereType<AddChartTabTask>().firstWhere(
            (t) => t.id == taskId,
            orElse: () => AddChartTabTask(tabTitle: '', id: taskId));
        _activeChartStartOffset = chartTask.fromPoint;
        _activeChartEndOffset = chartTask.tillPoint;
      }
    }
    _navigateToPage(targetIndex).then((_) => _onTaskFinish());
  }

  void _handlePopup() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      final colors =
          TLW().themeData?.customColors ?? Theme.of(context).customColors;
      showDialog(
          context: context,
          barrierColor:
              colors.dynamicChartBlurBg.withAlpha((0.5 * 255).round()),
          builder: (context) {
            final task = _currentTask as ShowPopupTask;
            return CustomDialogWidget(
                task: task, moveNext: () => Navigator.of(context).pop());
          }).then((_) => _onTaskFinish());
    });
    setState(() {});
  }

  void _handleBottomSheet() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      final colors =
          TLW().themeData?.customColors ?? Theme.of(context).customColors;
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          barrierColor:
              colors.dynamicChartBlurBg.withAlpha((0.5 * 255).round()),
          builder: (context) {
            final task = _currentTask as ShowBottomSheetTask;
            return CustomBottomSheetWidget(
                task: task,
                moveNext: () => Navigator.of(context).pop(),
                isCorrect: true);
          }).then((_) => _onTaskFinish());
    });
    setState(() {});
  }

  void _handleShowInsights() {
    _insightsTasks.add(_currentTask as ShowInsightsPageTask);
    setState(() {});
    _onTaskFinish();
  }

  void _handleChooseBucketRows() {
    final task = _currentTask as ChooseBucketRowsTask;
    final key = _previewScreenKeys[task.optionChainId];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (key != null &&
          task.bucketRows != null &&
          task.bucketRows!.isNotEmpty) {
        key.currentState
            ?.setBuySellSelections(task.bucketRows!.cast<finchart.OptionLeg>());
      }
    });
    _selectedLegs = (task.bucketRows ?? []).cast<finchart.OptionLeg>();
    setState(() {});
    _onTaskFinish();
  }

  void _handleClearBucketRows() {
    final task = _currentTask as ClearBucketRowsTask;
    final key = _previewScreenKeys[task.optionChainId];
    key?.currentState?.clearBucketSelections();
    _selectedLegs.clear();
    _onTaskFinish();
  }

  void _handleTableTask() {
    _tableTasks.add(_currentTask as TableTask);
    setState(() {});
    _onTaskFinish();
  }

  void _handleHighlightTableRow() {
    final task = _currentTask as HighlightTableRowTask;
    final tableTask = recipe.tasks
        .whereType<TableTask>()
        .firstWhere((t) => t.id == task.tableTaskId);
    final keys = _tableWidgetKeys[task.tableTaskId];
    if (keys != null) {
      for (int i = 0; i < tableTask.tables.tables.length; i++) {
        final key = keys[i];
        final selected = (task.selectedRows[i] != null)
            ? Set<int>.from(task.selectedRows[i]!)
            : <int>{};
        key.currentState?.setSelectedRows(selected);
      }
    }
    setState(() {});
    _onTaskFinish();
  }

  void _handleShowInsightsV2() {
    _v2insightsTasks.add(_currentTask as ShowInsightsPageV2Task);
    setState(() {});
    _onTaskFinish();
  }

  void _handleShowTools() {
    setState(() {
      _currentShowToolsTask = _currentTask as ShowToolsTask;
    });
    _onTaskFinish();
  }

  void _handleStartJourney() {
    final task = _currentTask as StartJourneyTask;
    setState(() {
      _journeys.add(JourneyState(id: task.journeyId));
      _activeJourneyId = task.journeyId;
      for (final item in _journeyItems) {
        if (item.id == task.journeyId) {
          item.active = true;
          break;
        }
      }
    });
    _onTaskFinish();
  }

  void _handleCompleteJourney() {
    setState(() {
      if (_activeJourneyId != null) {
        final journey = _journeys.firstWhere(
          (j) => j.id == _activeJourneyId,
          orElse: () => JourneyState(id: ''),
        );
        journey.completed = true;
        for (final item in _journeyItems) {
          if (item.id == _activeJourneyId) {
            item.completed = true;
            item.active = false;
            break;
          }
        }
      }
    });
    _onTaskFinish();
  }

  GlobalKey<ChartState>? _chartKeyForCurrentTab() {
    if (_currentPageIndex < 0 || _currentPageIndex >= _tabs.length) {
      if (_tabs.isNotEmpty && _tabs.first["type"] == "chart") {
        return _activeChartKey;
      }
      return _chartKey;
    }
    final tab = _tabs[_currentPageIndex];
    if (tab["type"] != "chart") return _activeChartKey ?? _chartKey;
    final taskId = tab["taskId"];
    if (taskId != null && _chartKeys.containsKey(taskId)) {
      return _chartKeys[taskId];
    }
    return _activeChartKey ?? _chartKey;
  }

  void _onTaskFinish() {
    _taskPointer += 1;
    if (_taskPointer < recipe.tasks.length) {
      _currentTask = recipe.tasks[_taskPointer];
      _onTaskRun();
    }
  }

  Future<void> _navigateToPage(int pageIndex) async {
    setState(() {
      _currentPageIndex = pageIndex;
      if (_tabs[pageIndex]["type"] == "option_chain") {
        _isOptionChainLoading = true;
      }
    });
    await _pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    if (_tabs[pageIndex]["type"] == "option_chain") {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) setState(() => _isOptionChainLoading = false);
    }
  }

  // ─── Tool handling ───

  List<SahiToolsModel> _buildToolsList() {
    final List<String> allToolNames = [
      ...IndicatorType.values.map((e) => e.name),
      ...LayerType.values.map((e) => e.name),
    ];
    final Map<String, bool> visibility = {};
    final Map<String, bool> enabled = {};
    final executed = recipe.tasks.sublist(0, _taskPointer);
    for (final t in executed) {
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
        setState(() => _selectedLayerType = layerType);
        chartState.updateLayerGettingAddedState(layerType);
        return;
      }
    }
  }

  void _onClearTools() {
    final chartState = _chartKeyForCurrentTab()?.currentState;
    chartState?.clearAllTools();
    setState(() {
      _selectedLayerType = null;
      _drawPoints.clear();
      _startingPoint = null;
    });
  }

  void _onChartInteraction(Offset tapDownPoint, Offset updatedPoint) {
    if (_selectedLayerType == null) return;
    _drawPoints.add(tapDownPoint);
    _startingPoint = updatedPoint;
    Layer? layer;
    switch (_selectedLayerType) {
      case LayerType.label:
        layer = Label.fromTool(
            pos: _drawPoints.first,
            label: "Text",
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold));
        break;
      case LayerType.trendLine:
        if (_drawPoints.length >= 2) {
          layer = TrendLine.fromTool(
              from: _drawPoints.first,
              to: _drawPoints.last,
              startPoint: _startingPoint!);
        }
        break;
      case LayerType.horizontalLine:
        layer = HorizontalLine.fromTool(value: _drawPoints.first.dy);
        break;
      case LayerType.horizontalBand:
        layer = HorizontalBand.fromTool(
            value: _drawPoints.first.dy, allowedError: 70);
        break;
      case LayerType.rectArea:
        if (_drawPoints.length >= 2) {
          layer = RectArea.fromTool(
              topLeft: _drawPoints.first,
              bottomRight: _drawPoints.last,
              dragStartPos: _startingPoint!);
        }
        break;
      case LayerType.circularArea:
        layer = CircularArea.fromTool(point: _drawPoints.first);
        break;
      case LayerType.arrow:
        if (_drawPoints.length >= 2) {
          layer = Arrow.fromTool(
              from: _drawPoints.first,
              to: _drawPoints.last,
              startPoint: _startingPoint!);
        }
        break;
      case LayerType.verticalLine:
        layer = VerticalLine.fromTool(pos: _drawPoints.first.dx);
        break;
      case LayerType.parallelChannel:
        if (_drawPoints.length >= 2) {
          layer = ParallelChannel.fromTool(
              topLeft: _drawPoints.first,
              bottomRight: _drawPoints.last,
              dragPoint: _startingPoint!);
        }
        break;
      case LayerType.arrowTextPointer:
        layer = ArrowTextPointer.fromTool(pos: _drawPoints.first, label: "");
        break;
      case null:
        break;
    }
    if (layer != null) {
      final chartState = _chartKeyForCurrentTab()?.currentState;
      if (chartState != null) {
        setState(() {
          _selectedLayerType = null;
          _drawPoints.clear();
        });
        chartState.addLayerUsingTool(layer);
      }
    }
  }

  void _onBuySellSelection(finchart.OptionLeg? leg) {
    if (leg != null) {
      _selectedLegs = [];
      setState(() => _selectedLegs.add(leg));
    }
  }

  // ─── Build ───

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Scaffold(
      appBar: SahiTopBar(
        streakDays: 0,
        xp: 0,
        unreadNotificationCount: 0,
        onNotificationTap: () {},
        onProfileTap: () {},
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildJourneyToolbar(colors),
          ),
          Expanded(
            flex: 3,
            child: _buildPromptPanel(colors),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 7,
            child: _buildChartArea(colors),
          ),
        ],
      ),
    );
  }

  // ─── Left: Journey Toolbar ───

  Widget _buildJourneyToolbar(CustomColors colors) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 0, 24),
      decoration: BoxDecoration(
        color: colors.sahiToolbarBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.sahiToolbarShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                  color: colors.sahiStreakColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.sahiUtilityBg, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 10,
                  ),
                  SizedBox(width: 4),
                  Text("Back", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: colors.sahiUtilityBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: colors.sahiToolbarActiveBg,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(140, 128, 229, 1),
                            Color.fromRGBO(224, 159, 135, 1),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text("Watch",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'JOURNEY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _journeyItems.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No journeys',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textColorSecondary,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                        color: colors.sahiUtilityBg,
                        borderRadius: BorderRadius.circular(16)),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: _journeyItems.length,
                      itemBuilder: (context, index) {
                        final item = _journeyItems[index];
                        return _JourneyToolbarItem(
                            item: item, colors: colors, index: index);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // ─── Middle: Prompt Panel ───

  Widget _buildPromptPanel(CustomColors colors) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 0, 24),
      decoration: BoxDecoration(
        color: colors.dynamicChartInstructionBG,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: _promptTask == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Waiting for instruction...',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textColorSecondary,
                        ),
                      ),
                    ),
                  )
                : _buildPromptContent(colors),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _userActionContainer(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptContent(CustomColors colors) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
      child: SizedBox(
        key: ValueKey(_promptTask),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _promptTask!.isExplanation
                      ? Text("Take Away", style: textStyles.smallBold)
                      : Text("Instruction", style: textStyles.mediumBold),
                  (_promptTask!.hint ?? "").isNotEmpty
                      ? TapTooltip(
                          message: 'Hint!\n${_promptTask!.hint}',
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.feedbackWidgetBG,
                            ),
                            child: SvgPicture.asset(
                              "assets/instruction_hint.svg",
                              package: 'tradeable_learn_widget/lib',
                              height: 20,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Spacer(),
                  const FeedbackWidget(),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: SingleChildScrollView(
                  child: MarkdownWidget(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    data: _promptTask?.promptText ?? "",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Right: Chart + Tabs + Action Area ───

  Widget _buildChartArea(CustomColors colors) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 14, 12, 24),
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (_tabs.isNotEmpty) _renderTabs(colors, textStyles),
          if (_currentShowToolsTask != null)
            SahiToolsBar(
              tools: _buildToolsList(),
              onToolTap: _onToolTap,
              trailing: GestureDetector(
                onTap: _onClearTools,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      Text('Clear',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2D2D2D))),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: _tabs.isEmpty
                ? const SizedBox.shrink()
                : PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final tab = _tabs[index];
                      switch (tab["type"]) {
                        case "chart":
                          return _buildChartTab(tab, colors);
                        case "option_chain":
                          return _buildOptionChainTab(tab, colors, textStyles);
                        case "payoff":
                          return _buildPayoffTab(tab, textStyles);
                        case "insights":
                          return _buildInsightsTab(tab);
                        case "table":
                          return _buildTableTab(tab);
                        case "insights_v2":
                          return _buildInsightsV2Tab(tab);
                        default:
                          return Container();
                      }
                    }),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab(Map<String, String> tab, CustomColors colors) {
    final taskId = tab["taskId"];
    final key = taskId != null && _chartKeys.containsKey(taskId)
        ? _chartKeys[taskId]!
        : _chartKey;
    return Container(
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      child: Chart.from(
          key: key, recipe: recipe, onInteraction: _onChartInteraction),
    );
  }

  Widget _buildOptionChainTab(
      Map<String, String> tab, CustomColors colors, CustomStyles textStyles) {
    if (_isOptionChainLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
            const SizedBox(height: 16),
            Text("Loading option chain...",
                style: textStyles.mediumNormal
                    .copyWith(color: colors.textColorSecondary)),
          ],
        ),
      );
    }
    final taskId = tab["taskId"]!;
    final chooseTask = recipe.tasks
        .whereType<ChooseCorrectOptionValueChainTask>()
        .firstWhere((t) => t.taskId == taskId);
    final optionChainTask = _optionChainTasks.firstWhere(
      (t) => t.optionChainId == chooseTask.taskId,
      orElse: () => _optionChainTasks.first,
    );
    return PreviewScreen.from(
        key: _previewScreenKeys[taskId] ?? GlobalKey(),
        task: optionChainTask,
        onViewChartClicked: () => _navigateToPage(0),
        onSettingsClicked: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => ColumnVisibilityEditor(
              columns: optionChainTask.columns,
              onVisibilityChanged: (updatedColumns) {
                setState(() => optionChainTask.columns = updatedColumns);
              },
            ),
          );
        },
        onBuySellSelected: _onBuySellSelection,
        isEditorMode: false);
  }

  Widget _buildPayoffTab(Map<String, String> tab, CustomStyles textStyles) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final taskId = tab["taskId"]!;
    final payoffTask = _payoffGraphTasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => _payoffGraphTasks.first,
    );
    return _selectedLegs.isEmpty
        ? Center(
            child: Text(
              "Select buy/sell positions in the option chain to view payoff",
              style: textStyles.mediumNormal
                  .copyWith(color: colors.textColorSecondary),
              textAlign: TextAlign.center,
            ),
          )
        : OptionStrategyContainer(
            spotPrice: payoffTask.spotPrice,
            spotPriceDayDelta: payoffTask.spotPriceDayDelta,
            spotPriceDayDeltaPer: payoffTask.spotPriceDayDeltaPer,
            onExecute: () {},
            legs: _selectedLegs
                .map((e) => strategy.OptionLeg.fromJson(e.toJson()))
                .toList(),
          );
  }

  Widget _buildInsightsTab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final task = recipe.tasks
        .whereType<ShowInsightsPageTask>()
        .firstWhere((t) => t.id == taskId, orElse: () => _insightsTasks.first);
    return InsightsWidget(insightsTask: task);
  }

  Widget _buildTableTab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final task =
        recipe.tasks.whereType<TableTask>().firstWhere((t) => t.id == taskId);
    if (_tableWidgetKeys[taskId] == null ||
        _tableWidgetKeys[taskId]!.length != task.tables.tables.length) {
      _tableWidgetKeys[taskId] = List.generate(
        task.tables.tables.length,
        (_) => GlobalKey<CustomTableState>(),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          task.tables.tables.length,
          (tableIdx) => CustomTable.from(
            key: _tableWidgetKeys[taskId]![tableIdx],
            tableTask: TableTask(
              tables: TablesModel(
                tables: [task.tables.tables[tableIdx]],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsV2Tab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final task = recipe.tasks.whereType<ShowInsightsPageV2Task>().firstWhere(
        (t) => t.id == taskId,
        orElse: () => _v2insightsTasks.first);
    return InsightsV2Widget(task: task);
  }

  // ─── Tabs bar ───

  IconData _getTabIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('chart')) return Icons.candlestick_chart_outlined;
    if (lower.contains('option')) return Icons.show_chart;
    if (lower.contains('payoff') || lower.contains('pay off')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (lower.contains('table')) return Icons.table_chart_outlined;
    if (lower.contains('insight')) return Icons.insights_outlined;
    return Icons.tab_outlined;
  }

  Widget _renderTabs(CustomColors colors, CustomStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.sahiTabBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.sahiTabBorder, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isActive = index == _currentPageIndex;
                final title = tab["title"] ?? "";
                return GestureDetector(
                  onTap: () => _navigateToPage(index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.sahiPanelItemBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.sahiTabBorder, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTabIcon(title),
                          size: 14,
                          color: isActive
                              ? colors.sahiTabActiveBg
                              : colors.sahiTabInactiveText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          title,
                          style: TextStyle(
                            color: isActive
                                ? colors.sahiTabActiveBg
                                : colors.sahiTabInactiveText,
                            fontSize: 13,
                            fontWeight:
                                isActive ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ─── User action area ───

  Widget _userActionContainer(CustomColors colors) {
    switch (_currentTask.taskType) {
      case TaskType.addData:
      case TaskType.addIndicator:
      case TaskType.addLayer:
      case TaskType.addPrompt:
        return const SizedBox.shrink();
      case TaskType.addMcq:
        return _mcqWidget(colors);
      case TaskType.waitTask:
        return ButtonWidget(
          color: colors.sahiToolbarActiveIconColor,
          btnContent: (_currentTask as WaitTask).btnText,
          onTap: () => _onTaskFinish(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _mcqWidget(CustomColors colors) {
    if (_currentTask is! AddMcqTask) return const SizedBox.shrink();
    final mcqTask = _currentTask as AddMcqTask;
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
            onTap: () => _onTaskFinish(),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colors.buttonColor,
                border: Border.all(color: colors.cardColorSecondary),
              ),
              child: Center(child: Text(mcqTask.options[index])),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// ─── Journey toolbar item model ───

class _JourneyItem {
  final String id;
  bool active;
  bool completed;

  _JourneyItem({
    required this.id,
    this.active = false,
    this.completed = false,
  });
}

// ─── Journey toolbar item widget ───

class _JourneyToolbarItem extends StatelessWidget {
  final _JourneyItem item;
  final CustomColors colors;
  final int index;

  const _JourneyToolbarItem({
    required this.item,
    required this.colors,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = item.active
        ? colors.sahiToolbarActiveIconColor
        : colors.sahiToolbarIconColor;

    final bgColor =
        item.active ? colors.sahiToolbarActiveBg : Colors.transparent;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: iconColor,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(4),
        child: Center(
          child: Text(
            index.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
