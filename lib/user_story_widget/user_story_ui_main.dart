import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_data_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_buttons.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_table.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_text.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/mcq_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_info.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_sheet.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/tradeable_chart.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class UserStoryUIMain extends StatefulWidget {
  final UserStoryModel model;
  final VoidCallback onNextClick;

  const UserStoryUIMain(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<StatefulWidget> createState() => _UserStoryUIMainState();
}

class _UserStoryUIMainState
    extends State<UserStoryUIMain> {
  String currentStepId = '';
  final ScrollController _scrollController = ScrollController();
  RowData? highlightedRowData;
  bool? isAnsweredCorrect;
  String status = 'Open';

  @override
  void initState() {
    super.initState();
    if (widget.model.marketDepthUserStory.steps.isNotEmpty) {
      currentStepId = widget.model.marketDepthUserStory.steps.first.stepId;
    }
  }

  void moveToNextStep() {
    setState(() {
      isAnsweredCorrect = null;
    });
    final currentIndex = widget.model.marketDepthUserStory.steps
        .indexWhere((step) => step.stepId == currentStepId);
    if (currentIndex >= 0 &&
        currentIndex < widget.model.marketDepthUserStory.steps.length - 1) {
      setState(() {
        currentStepId =
            widget.model.marketDepthUserStory.steps[currentIndex + 1].stepId;
      });
      _scrollController
          .animateTo(200,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut)
          .then((_) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
      });
    }
  }

  void confirmOrder() {
    final currentIndex = widget.model.marketDepthUserStory.steps
        .indexWhere((step) => step.stepId == currentStepId);
    if (currentIndex >= 0 &&
        currentIndex < widget.model.marketDepthUserStory.steps.length - 1) {
      setState(() {
        currentStepId =
            widget.model.marketDepthUserStory.steps[currentIndex + 1].stepId;
      });

      for (StepData step in widget.model.marketDepthUserStory.steps) {
        for (UiData uiData in step.ui) {
          if (uiData.tableData != null) {
            for (var table in uiData.tableData!) {
              for (var row in table.data) {
                if (row.price == highlightedRowData?.price) {
                  int currentQuantity = int.parse(row.quantity);
                  Future.doWhile(() async {
                    if (currentQuantity > 0) {
                      await Future.delayed(const Duration(milliseconds: 20),
                          () {
                        setState(() {
                          currentQuantity--;
                          row.quantity = currentQuantity.toString();
                        });
                      });
                      return true;
                    } else {
                      setState(() {
                        status = 'Executed';
                      });
                    }
                    return false;
                  });
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    final step = widget.model.marketDepthUserStory.steps.firstWhere(
      (step) => step.stepId == currentStepId,
      orElse: () => StepData(stepId: '', ui: [], isActionNeeded: false),
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: step.ui.map((uiData) {
                switch (uiData.widget) {
                  case "AnimatedText":
                    return AnimatedTextWidget(
                        prompt: uiData.prompt, title: uiData.title);
                  case "MarketDepthTable":
                    return MarketDepthTableWidget(
                      tableAlignment: uiData.tableAlignment ?? "horizontal",
                      tableData: uiData.tableData ?? [],
                      title: uiData.title,
                      highlightedRowData: highlightedRowData,
                    );
                  case "Buttons":
                    return MultipleButtonsWidget(
                      buttonsFormat: uiData.buttonsFormat ?? "horizontal",
                      buttonsData: uiData.buttonsData ?? [],
                      onAction: moveToNextStep,
                    );
                  case "TradeSheet":
                    return TradeSheet(
                      tableRowDataMap: getTableRowDataAsMap(
                        widget.model.marketDepthUserStory.steps
                            .firstWhere(
                              (step) => step.stepId == currentStepId,
                            )
                            .ui
                            .firstWhere(
                              (ui) => ui.tableData != null,
                            )
                            .tableData!,
                      ),
                      onRowDataSelected: (RowData data) {
                        setState(() {
                          highlightedRowData = data;
                        });
                      },
                    );
                  case "MCQQuestion":
                    return MCQQuestionWidget(
                      title: uiData.title,
                      format: uiData.format ?? "",
                      options: uiData.options ?? [],
                      correctResponse: uiData.correctResponse ?? [],
                      onOptionSelected: (selectedItems) {
                        setState(() {
                          isAnsweredCorrect = Set.from(selectedItems)
                                  .difference(
                                      Set.from(uiData.correctResponse ?? []))
                                  .isEmpty &&
                              selectedItems.length ==
                                  (uiData.correctResponse ?? []).length;
                        });
                      },
                    );
                  case "PlainText":
                    return Markdown(
                      data: uiData.prompt,
                      shrinkWrap: true,
                    );
                  case "HorizontalLineChart":
                    return SizedBox(
                        height: 350,
                        child: TradeableChart(model: uiData.chart!));
                  case "TradeInfo":
                    return TradeInfo(
                        title: uiData.title,
                        limitPrice: highlightedRowData?.price ?? '',
                        quantity: highlightedRowData?.quantity ?? '',
                        status: status);
                  default:
                    return const SizedBox.shrink();
                }
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
            color: !(step.isActionNeeded) ||
                    isAnsweredCorrect != null ||
                    highlightedRowData != null
                ? colors.primary
                : colors.secondary,
            btnContent: step.ui.last.title,
            onTap: () {
              if (isAnsweredCorrect != null ||
                  highlightedRowData != null ||
                  !(step.isActionNeeded)) {
                switch (step.ui.last.action) {
                  case "moveNext":
                    widget.onNextClick();
                    break;
                  case "confirmOrder":
                    confirmOrder();
                    break;
                  case "submitResponse":
                    showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context) => BottomSheetWidget(
                            isCorrect: isAnsweredCorrect ?? false,
                            model: widget.model.explanationV1,
                            onNextClick: () {
                              moveToNextStep();
                            }));
                    break;
                  case "moveToNextStep":
                    moveToNextStep();
                    break;
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Map<int, List<RowData>> getTableRowDataAsMap(List<TableData> tableDataList) {
    Map<int, List<RowData>> tableRowDataMap = {};

    for (int tableIndex = 0; tableIndex < tableDataList.length; tableIndex++) {
      tableRowDataMap[tableIndex] = tableDataList[tableIndex].data;
    }

    return tableRowDataMap;
  }
}

class MarketDepthTableWidget extends StatelessWidget {
  final String title;
  final String tableAlignment;
  final List<TableData> tableData;
  final RowData? highlightedRowData;

  const MarketDepthTableWidget({
    super.key,
    required this.title,
    required this.tableAlignment,
    required this.tableData,
    this.highlightedRowData,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> tables = tableData.map((tableEntry) {
      final headers = ['Bid', 'Orders', 'Qty'];

      final rows = tableEntry.data
          .map((row) => [
                row.price,
                row.orders,
                row.quantity,
              ])
          .toList();

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomTable(
          title: tableEntry.title,
          headers: headers,
          rows: rows,
          headerGradientColors:
              tableEntry.tableColors.map((e) => Color(int.parse(e))).toList(),
          footerLabel: 'Total Orders',
          footerValue: tableEntry.totalValue,
          footerValueColor: Colors.black,
          highlightedRowData: highlightedRowData,
        ),
      );
    }).toList();

    return tableAlignment == 'horizontal'
        ? Row(
            children: tables.map((table) => Expanded(child: table)).toList(),
          )
        : Column(
            children: tables.map((table) => table).toList(),
          );
  }
}
