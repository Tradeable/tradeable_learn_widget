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
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/custom_bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/insights_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/option_chain/column_visibility_editor.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_container.dart';
import 'package:tradeable_learn_widget/sahi/widgets/instruction_content.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_toolbar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/prompt_panel.dart';
import 'package:tradeable_learn_widget/sahi/widgets/questions_tab.dart';
import 'package:tradeable_learn_widget/sahi/widgets/response_archive.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_custom_table.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_dialog_widget.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_insights_v2.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_preview_screen.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_tabbar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_tools_bar.dart';
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
  PageController pageController = PageController();
  List<Map<String, String>> tabs = [];
  int _currentPageIndex = 0;

  // Chart keys
  Map<String, GlobalKey<ChartState>> chartKeys = {};
  GlobalKey<ChartState> chartKey = GlobalKey();
  GlobalKey<ChartState>? _activeChartKey;
  String? _activeChartId;
  int _activeChartStartOffset = 0;
  int _activeChartEndOffset = -1;
  final Map<String, bool> _hasPlottedFirstChunk = {};

  // Option chain
  Map<String, GlobalKey<SahiPreviewScreenState>> previewScreenKeys = {};
  List<finchart.OptionLeg> _selectedLegs = [];
  List<AddOptionChainTask> optionChainTasks = [];
  bool _isOptionChainLoading = false;

  // Other content
  List<ShowPayOffGraphTask> payoffGraphTasks = [];
  List<ShowInsightsPageTask> insightsTasks = [];
  List<ShowInsightsPageV2Task> v2insightsTasks = [];
  AddCoreConceptTask? coreConcepts;
  List<TableTask> tableTasks = [];
  Map<String, List<GlobalKey<SahiCustomTableState>>> tableWidgetKeys = {};

  // Tools
  ShowToolsTask? _currentShowToolsTask;
  AddRemoveToolsTask? _currentAddRemoveToolsTask;
  LayerType? _selectedLayerType;
  String? _selectedToolTitle;
  List<Offset> drawPoints = [];
  Offset? _startingPoint;

  // Journeys
  List<JourneyItem> _journeyItems = [];
  List<JourneyState> journeys = [];
  String? _activeJourneyId;
  String? courseVideoUrl;
  bool showCourseVideoBtn = false;

  // Side nav
  List<ShowSideNavTask> sideNavTasks = [];
  List<ShowSideNavTask> answeredSideNavTasks = [];
  Map<String, String?> sideNavSelectedDesc = {};
  String? expandedSideNavId;
  bool _questionOptionSelected = false;
  int _promptPanelTabIndex = 0;

  @override
  void initState() {
    super.initState();
    recipe = widget.model.recipe;
    _extractJourneys();

    if (recipe.tasks.isNotEmpty) {
      _currentTask = recipe.tasks.first;
      _runAfterDelay();
    }
    _activeChartKey = chartKey;
  }

  void _extractJourneys() {
    final startTasks = recipe.tasks.whereType<StartJourneyTask>().toList();
    _journeyItems =
        startTasks.map((t) => JourneyItem(id: t.journeyId)).toList();
  }

  void _runAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _onTaskRun();
  }

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
      case TaskType.showSideNav:
        _handleShowSideNav();
        break;
      case TaskType.showTools:
        _handleShowTools();
        break;
      case TaskType.toggleToolVisibility:
        setState(() {});
        _onTaskFinish();
        break;
      case TaskType.addRemoveTools:
        final task = _currentTask as AddRemoveToolsTask;
        setState(() {
          _currentAddRemoveToolsTask = task;
        });
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
        final task = _currentTask as AttachVideoToJourneyTask;
        if (_activeJourneyId == null) {
          _onTaskFinish();
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
        _onTaskFinish();
        break;
      case TaskType.hideVideoBtnInJourney:
        final task = _currentTask as HideVideoBtnInJourneyTask;
        if (_activeJourneyId == null) {
          _onTaskFinish();
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
        _onTaskFinish();
        break;
      case TaskType.addCourseVideo:
        final task = _currentTask as AddCourseVideoTask;
        setState(() {
          courseVideoUrl = task.videoUrl;
          showCourseVideoBtn = true;
        });
        _onTaskFinish();
        break;
      case TaskType.addCoreConcept:
        setState(() {
          coreConcepts = _currentTask as AddCoreConceptTask;
        });
        _onTaskFinish();
        break;
      case TaskType.removeCoreConcept:
        setState(() {
          coreConcepts = null;
        });
        _onTaskFinish();
        break;
    }
  }

  void _handleAddData() {
    final task = _currentTask as AddDataTask;
    final key =
        task.chartId != null ? chartKeys[task.chartId] : _activeChartKey;
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
        task.chartId != null ? chartKeys[task.chartId] : _activeChartKey;
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
    final key = chartKeyForCurrentTab();
    key?.currentState?.clearChart();
    _onTaskFinish();
  }

  void _handleAddOptionChain() {
    final task = _currentTask as AddOptionChainTask;
    if (!optionChainTasks.any((t) => t.optionChainId == task.optionChainId)) {
      optionChainTasks.add(task);
    }
    setState(() {});
    _onTaskFinish();
  }

  void _handleHighlightOptionChain() {
    final task = _currentTask as HighlightCorrectOptionChainValueTask;
    final key = previewScreenKeys[task.optionChainId];
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
    payoffGraphTasks.add(_currentTask as ShowPayOffGraphTask);
    _onTaskFinish();
  }

  void _handleAddChartTab() {
    setState(() {
      final task = _currentTask as AddChartTabTask;
      final key = GlobalKey<ChartState>();
      chartKeys[task.id] = key;
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
        final existingIndex = tabs.indexWhere(
            (tab) => tab["type"] == "chart" && tab["taskId"] == task.taskId);
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
      if (addedIndex >= 0 && addedIndex != _currentPageIndex) {
        _navigateToPage(addedIndex).then((_) => _onTaskFinish());
      } else {
        _onTaskFinish();
      }
    } else {
      int addedIndex = -1;
      setState(() {
        previewScreenKeys[task.taskId] = GlobalKey<SahiPreviewScreenState>();
        if (!tabs.any((tab) => tab["taskId"] == task.taskId)) {
          if (recipe.tasks.any((t) =>
              t is ChooseCorrectOptionValueChainTask &&
              t.taskId == task.taskId)) {
            tabs.add({
              "type": "option_chain",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = tabs.length - 1;
          } else if (recipe.tasks
              .any((t) => t is ShowInsightsPageTask && t.id == task.taskId)) {
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
          } else if (recipe.tasks
              .any((t) => t is ShowPayOffGraphTask && t.id == task.taskId)) {
            tabs.add({
              "type": "payoff",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = tabs.length - 1;
          } else if (recipe.tasks
              .any((t) => t is ShowInsightsPageV2Task && t.id == task.taskId)) {
            tabs.add({
              "type": "insights_v2",
              "title": task.tabTitle,
              "taskId": task.taskId,
            });
            addedIndex = tabs.length - 1;
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
      final removed = tabs.firstWhere(
        (tab) => tab["title"] == task.tabTitle,
        orElse: () => {},
      );
      if (removed["type"] == "chart" && removed["taskId"] != null) {
        chartKeys.remove(removed["taskId"]);
      }
      tabs.removeWhere((tab) => tab["title"] == task.tabTitle);
    });
    _onTaskFinish();
  }

  void _handleMoveTab() {
    final task = _currentTask as MoveTabTask;
    if (task.tabTaskID == "chart") {
      _navigateToPage(0).then((_) => _onTaskFinish());
      return;
    }
    final targetIndex = tabs.indexWhere(
      (tab) => tab["taskId"] == task.tabTaskID,
    );
    if (targetIndex == -1) {
      _onTaskFinish();
      return;
    }
    final targetTab = tabs[targetIndex];
    if (targetTab["type"] == "chart") {
      final taskId = targetTab["taskId"];
      if (taskId != null && chartKeys.containsKey(taskId)) {
        _activeChartId = taskId;
        _activeChartKey = chartKeys[taskId];
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
            return SahiDialogWidget(
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
    insightsTasks.add(_currentTask as ShowInsightsPageTask);
    setState(() {});
    _onTaskFinish();
  }

  void _handleChooseBucketRows() {
    final task = _currentTask as ChooseBucketRowsTask;
    final key = previewScreenKeys[task.optionChainId];
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
    final key = previewScreenKeys[task.optionChainId];
    key?.currentState?.clearBucketSelections();
    _selectedLegs.clear();
    _onTaskFinish();
  }

  void _handleTableTask() {
    tableTasks.add(_currentTask as TableTask);
    setState(() {});
    _onTaskFinish();
  }

  void _handleHighlightTableRow() {
    final task = _currentTask as HighlightTableRowTask;
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
        key.currentState?.setSelectedRows(selected);
      }
    }
    setState(() {});
    _onTaskFinish();
  }

  void _handleShowInsightsV2() {
    v2insightsTasks.add(_currentTask as ShowInsightsPageV2Task);
    setState(() {});
    _onTaskFinish();
  }

  void _handleShowTools() {
    setState(() {
      _currentShowToolsTask = _currentTask as ShowToolsTask;
    });
    _onTaskFinish();
  }

  void _handleShowSideNav() {
    final task = _currentTask as ShowSideNavTask;
    setState(() {
      if (!sideNavTasks.any((t) => t.id == task.id)) {
        sideNavTasks.add(task);
      }
      _questionOptionSelected = false;
      expandedSideNavId = task.id;
      _promptPanelTabIndex = 1;
    });
  }

  void _handleStartJourney() {
    final task = _currentTask as StartJourneyTask;
    setState(() {
      for (final item in _journeyItems) {
        if (item.active) {
          item.active = false;
          item.completed = true;
        }
      }
      journeys.add(JourneyState(id: task.journeyId));
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
        final journey = journeys.firstWhere(
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

  GlobalKey<ChartState>? chartKeyForCurrentTab() {
    if (_currentPageIndex < 0 || _currentPageIndex >= tabs.length) {
      if (tabs.isNotEmpty && tabs.first["type"] == "chart") {
        return _activeChartKey;
      }
      return chartKey;
    }
    final tab = tabs[_currentPageIndex];
    if (tab["type"] != "chart") return _activeChartKey ?? chartKey;
    final taskId = tab["taskId"];
    if (taskId != null && chartKeys.containsKey(taskId)) {
      return chartKeys[taskId];
    }
    return _activeChartKey ?? chartKey;
  }

  void _onTaskFinish() {
    if (_selectedToolTitle != null && mounted) {
      setState(() => _selectedToolTitle = null);
    }
    _taskPointer += 1;
    if (_taskPointer < recipe.tasks.length) {
      _currentTask = recipe.tasks[_taskPointer];
      _onTaskRun();
    }
  }

  Future<void> _navigateToPage(int pageIndex) async {
    setState(() {
      _currentPageIndex = pageIndex;
      if (tabs[pageIndex]["type"] == "option_chain") {
        _isOptionChainLoading = true;
      }
    });
    await pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    if (tabs[pageIndex]["type"] == "option_chain") {
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
    final chartState = chartKeyForCurrentTab()?.currentState;
    if (chartState == null) return;

    for (final indicatorType in IndicatorType.values) {
      if (indicatorType.name == toolName) {
        final config = _currentAddRemoveToolsTask?.getToolConfig(toolName);
        Indicator indicator;
        if (config != null) {
          indicator = Indicator.fromJson(json: config);
        } else {
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
        }
        setState(() => _selectedToolTitle = toolName);
        chartState.addIndicator(indicator);
        return;
      }
    }

    for (final layerType in LayerType.values) {
      if (layerType.name == toolName) {
        setState(() {
          _selectedLayerType = layerType;
          _selectedToolTitle = toolName;
        });
        chartState.updateLayerGettingAddedState(layerType);
        return;
      }
    }
  }

  void _onClearTools() {
    final chartState = chartKeyForCurrentTab()?.currentState;
    chartState?.clearAllTools();
    setState(() {
      _selectedLayerType = null;
      drawPoints.clear();
      _startingPoint = null;
    });
  }

  void _onChartInteraction(Offset tapDownPoint, Offset updatedPoint) {
    if (_selectedLayerType == null) return;
    drawPoints.add(tapDownPoint);
    _startingPoint = updatedPoint;
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
              startPoint: _startingPoint!);
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
              dragStartPos: _startingPoint!);
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
              startPoint: _startingPoint!);
        }
        break;
      case LayerType.verticalLine:
        layer = VerticalLine.fromTool(pos: drawPoints.first.dx);
        break;
      case LayerType.parallelChannel:
        if (drawPoints.length >= 2) {
          layer = ParallelChannel.fromTool(
              topLeft: drawPoints.first,
              bottomRight: drawPoints.last,
              dragPoint: _startingPoint!);
        }
        break;
      case LayerType.arrowTextPointer:
        layer = ArrowTextPointer.fromTool(pos: drawPoints.first, label: "");
        break;
      case null:
        break;
    }
    if (layer != null) {
      layer = _applyLayerConfig(layer);
      final chartState = chartKeyForCurrentTab()?.currentState;
      if (chartState != null) {
        setState(() {
          _selectedLayerType = null;
          drawPoints.clear();
        });
        chartState.addLayerUsingTool(layer);
      }
    }
  }

  Layer _applyLayerConfig(Layer layer) {
    final config = _currentAddRemoveToolsTask?.getToolConfig(layer.type.name);
    if (config == null) return layer;

    switch (layer.type) {
      case LayerType.horizontalLine:
        final c = HorizontalLine.fromJson(json: config);
        final l = layer as HorizontalLine;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        break;
      case LayerType.trendLine:
        final c = TrendLine.fromJson(json: config);
        final l = layer as TrendLine;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        l.endPointRadius = c.endPointRadius;
        break;
      case LayerType.label:
        final c = Label.fromJson(json: config);
        final l = layer as Label;
        l.label = c.label;
        l.textStyle = c.textStyle;
        break;
      case LayerType.horizontalBand:
        final c = HorizontalBand.fromJson(json: config);
        final l = layer as HorizontalBand;
        l.color = c.color;
        l.allowedError = c.allowedError;
        break;
      case LayerType.rectArea:
        final c = RectArea.fromJson(json: config);
        final l = layer as RectArea;
        l.color = c.color;
        l.alpha = c.alpha;
        l.strokeWidth = c.strokeWidth;
        l.endPointRadius = c.endPointRadius;
        l.isLocked = c.isLocked;
        break;
      case LayerType.circularArea:
        final c = CircularArea.fromJson(json: config);
        final l = layer as CircularArea;
        l.color = c.color;
        l.radius = c.radius;
        break;
      case LayerType.arrow:
        final c = Arrow.fromJson(json: config);
        final l = layer as Arrow;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        l.endPointRadius = c.endPointRadius;
        l.arrowheadSize = c.arrowheadSize;
        l.isArrowheadAtTo = c.isArrowheadAtTo;
        break;
      case LayerType.parallelChannel:
        final c = ParallelChannel.fromJson(json: config);
        final l = layer as ParallelChannel;
        l.color = c.color;
        l.strokeWidth = c.strokeWidth;
        l.channelAlpha = c.channelAlpha;
        l.endPointRadius = c.endPointRadius;
        break;
      case LayerType.arrowTextPointer:
        final c = ArrowTextPointer.fromJson(json: config);
        final l = layer as ArrowTextPointer;
        l.label = c.label;
        l.textAlignment = c.textAlignment;
        break;
      case LayerType.verticalLine:
        break;
    }
    return layer;
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: totalWidth * 0.06,
                    child: JourneyToolbar(
                      items: _journeyItems,
                      colors: colors,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(
                    width: totalWidth * 0.24,
                    child: PromptPanel(
                      colors: colors,
                      tabIndex: _promptPanelTabIndex,
                      onTabChange: (index) =>
                          setState(() => _promptPanelTabIndex = index),
                      coreConcepts: coreConcepts,
                      instructionBody: InstructionContent(
                        task: _promptTask,
                        colors: colors,
                      ),
                      questionsBody: QuestionsTab(
                        tasks: sideNavTasks
                            .where((t) => !answeredSideNavTasks
                                .any((a) => a.id == t.id))
                            .toList(),
                        expandedTaskId: expandedSideNavId,
                        selectedDescriptions: sideNavSelectedDesc,
                        colors: colors,
                        onOptionSelect: (task, description) {
                          setState(() {
                            expandedSideNavId = task.id;
                            sideNavSelectedDesc[task.id] = description;
                            _questionOptionSelected = true;
                          });
                        },
                      ),
                      responseArchiveBody: ResponseArchive(
                        tasks: answeredSideNavTasks,
                        selectedDescriptions: sideNavSelectedDesc,
                        colors: colors,
                      ),
                      actionContainer: _userActionContainer(colors),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: totalWidth * 0.70 - 12,
                    child: _buildChartArea(colors),
                  ),
                ],
              ),
            ],
          );
        },
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
          SahiTabBar(
            tabs: tabs,
            currentPageIndex: _currentPageIndex,
            onTabTap: _navigateToPage,
            activeJourney: _activeJourneyId != null
                ? journeys.firstWhere(
                    (j) => j.id == _activeJourneyId,
                    orElse: () => JourneyState(id: ''),
                  )
                : null,
            courseVideoUrl: courseVideoUrl,
            showCourseVideoBtn: showCourseVideoBtn,
          ),
          if (_currentShowToolsTask != null)
            SahiToolsBar(
              tools: _buildToolsList(),
              onToolTap: _onToolTap,
              activeToolTitle: _selectedToolTitle,
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
            child: tabs.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    color: Color(0xffFBFBFD),
                    child: PageView.builder(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final tab = tabs[index];
                          switch (tab["type"]) {
                            case "chart":
                              return _buildChartTab(tab, colors);
                            case "option_chain":
                              return _buildOptionChainTab(
                                  tab, colors, textStyles);
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
          ),
        ],
      ),
    );
  }

  // Future<void> navigateToPage(int pageIndex) async {
  //   setState(() {
  //     _currentPageIndex = pageIndex;
  //   });
  // }

  Widget _buildChartTab(Map<String, String> tab, CustomColors colors) {
    final taskId = tab["taskId"];
    final key = taskId != null && chartKeys.containsKey(taskId)
        ? chartKeys[taskId]!
        : chartKey;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFBFBFD),
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
    final optionChainTask = optionChainTasks.firstWhere(
      (t) => t.optionChainId == chooseTask.taskId,
      orElse: () => optionChainTasks.first,
    );
    return SahiPreviewScreen.from(
        key: previewScreenKeys[taskId] ?? GlobalKey(),
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
    final payoffTask = payoffGraphTasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => payoffGraphTasks.first,
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
        .firstWhere((t) => t.id == taskId, orElse: () => insightsTasks.first);
    return InsightsWidget(insightsTask: task);
  }

  Widget _buildTableTab(Map<String, String> tab) {
    final taskId = tab["taskId"]!;
    final task =
        recipe.tasks.whereType<TableTask>().firstWhere((t) => t.id == taskId);
    if (tableWidgetKeys[taskId] == null ||
        tableWidgetKeys[taskId]!.length != task.tables.tables.length) {
      tableWidgetKeys[taskId] = List.generate(
        task.tables.tables.length,
        (_) => GlobalKey<SahiCustomTableState>(),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          task.tables.tables.length,
          (tableIdx) => SahiCustomTable.from(
            key: tableWidgetKeys[taskId]![tableIdx],
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
    final task = recipe.tasks
        .whereType<ShowInsightsPageV2Task>()
        .firstWhere((t) => t.id == taskId, orElse: () => v2insightsTasks.first);
    return SahiInsightsV2(task: task);
  }

  // ─── User action area ───

  Widget _userActionContainer(CustomColors colors) {
    if (_promptPanelTabIndex == 1 && _questionOptionSelected) {
      return ButtonWidget(
        color: colors.sahiToolbarActiveIconColor,
        btnContent: 'Next',
        onTap: () {
          setState(() {
            final answered = sideNavTasks
                .where((t) => t.id == expandedSideNavId)
                .toList();
            for (final t in answered) {
              if (!answeredSideNavTasks.any((a) => a.id == t.id)) {
                answeredSideNavTasks.add(t);
              }
            }
            expandedSideNavId = null;
            _promptPanelTabIndex = 0;
            _questionOptionSelected = false;
          });
          _onTaskFinish();
        },
      );
    }
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
    pageController.dispose();
    super.dispose();
  }
}
