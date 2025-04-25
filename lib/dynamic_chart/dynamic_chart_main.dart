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

  int? _selectedRating;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    recipe = widget.model.recipe;
    if (recipe.tasks.isNotEmpty) {
      currentTask = recipe.tasks.first;
      dd();
    }
    super.initState();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
                        ],
                      ))),
            ),

          // Feedback button - small and ignorable as requested
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.feedback_outlined,
                  color: colors.textColorSecondary,
                  size: 20,
                ),
                tooltip: "Provide feedback",
                onPressed: _showFeedbackDialog,
              ),
            ),
          ),
          Expanded(
              child: Chart.from(
                  key: _chartKey, recipe: recipe, onInteraction: (p0, p1) {})),
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

  // Feedback dialog to capture user's rating and comments
  void _showFeedbackDialog() {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    _selectedRating = null;
    _feedbackController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Helper to get hint text based on rating
            String getHintText() {
              switch (_selectedRating) {
                case 1:
                  return "What made this content so unhelpful?";
                case 2:
                  return "What could have made this more helpful?";
                case 3:
                  return "What were you looking for specifically?";
                case 4:
                  return "What improvements would you suggest?";
                default:
                  return "Tell us your thoughts...";
              }
            }

            // Helper to get rating description
            String getRatingDescription() {
              switch (_selectedRating) {
                case 1:
                  return "Absolute rubbish";
                case 2:
                  return "Nice but not helpful";
                case 3:
                  return "Helpful but not what I was looking for";
                case 4:
                  return "I liked it but need improvements";
                case 5:
                  return "More of this!";
                default:
                  return "Rate your experience";
              }
            }

            return AlertDialog(
              backgroundColor: colors.cardColorPrimary,
              title: Text("Your Feedback", style: textStyles.smallBold),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("How would you rate this content?",
                        style: textStyles.smallNormal),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRating = starValue;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              _selectedRating != null &&
                                      _selectedRating! >= starValue
                                  ? Icons.star
                                  : Icons.star_border,
                              color: _selectedRating != null &&
                                      _selectedRating! >= starValue
                                  ? colors.primary
                                  : colors.textColorSecondary,
                              size: 28,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        getRatingDescription(),
                        style: textStyles.smallNormal.copyWith(
                          color: colors.textColorSecondary,
                          //fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (_selectedRating != null && _selectedRating! < 5) ...[
                      Text("Your Review", style: textStyles.smallNormal),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.cardColorSecondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _feedbackController,
                          maxLines: 3,
                          style: textStyles.smallNormal,
                          decoration: InputDecoration(
                            hintText: getHintText(),
                            hintStyle: textStyles.smallNormal
                                .copyWith(color: colors.textColorSecondary),
                            contentPadding: const EdgeInsets.all(10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel",
                      style: textStyles.smallNormal
                          .copyWith(color: colors.textColorSecondary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Submit",
                      style: textStyles.smallNormal
                          .copyWith(color: colors.primary)),
                  onPressed: () {
                    // Add logic to handle feedback submission
                    // For now just close the dialog
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
