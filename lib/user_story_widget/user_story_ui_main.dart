import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/horizontal_line_model.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/reel_range_response.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/range_layer/range_layer.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/option_chain_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_data_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_buttons.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_mcq_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_text.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/market_depth_user_table.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/mcq_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/mcq_widget_v1.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/option_chain_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/option_trade_sheet.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/order_status_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/ticket_coupon_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_info.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_sheet.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/tradeable_chart.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trend_line_chart.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/volume_chart.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/volume_price_slider.dart';
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

class _UserStoryUIMainState extends State<UserStoryUIMain> {
  String currentStepId = '';
  final ScrollController _scrollController = ScrollController();
  RowData? highlightedRowData;
  bool? isAnsweredCorrect;
  String status = 'Open';
  List<String> selectedResponses = [];
  bool showBottomSheet = false;
  RowData? staticHighlightedRowData;
  OptionEntry? selectedOptionEntry;
  String? quantity;

  @override
  void initState() {
    super.initState();
    if (widget.model.userStory.steps.isNotEmpty) {
      currentStepId = widget.model.userStory.steps
          .firstWhere((step) => step.stepId == "1",
              orElse: () => widget.model.userStory.steps.first)
          .stepId;
    }

    WidgetsBinding.instance.addPostFrameCallback((a) {
      animatePageScroll();
    });
  }

  void animatePageScroll() {
    if (_scrollController.position.maxScrollExtent > 0) {
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

  void moveToNextStep() {
    setState(() {
      isAnsweredCorrect = null;
      selectedResponses.clear();
    });
    final currentIndex = widget.model.userStory.steps
        .indexWhere((step) => step.stepId == currentStepId);
    if (currentIndex >= 0 &&
        currentIndex < widget.model.userStory.steps.length - 1) {
      setState(() {
        currentStepId = widget.model.userStory.steps[currentIndex + 1].stepId;
      });
      animatePageScroll();
    }
  }

  void confirmOrder(bool isQuantitySquared) {
    moveToNextStep();
    setState(() {
      staticHighlightedRowData ??= highlightedRowData;
    });
    for (StepData step in widget.model.userStory.steps) {
      for (UiData uiData in step.ui) {
        if (uiData.tableModel != null) {
          for (var table in uiData.tableModel!.tableData!) {
            for (var row in table.data) {
              if (row.price == highlightedRowData?.price &&
                  row.orders == highlightedRowData?.orders) {
                setState(() {
                  row.quantity = highlightedRowData?.quantity ?? row.quantity;
                });
                _decreaseQuantity(row, isQuantitySquared, table);
                break;
              }
            }
          }
        }
      }
    }
  }

  void _decreaseQuantity(RowData row, bool isQuantitySquared, TableData table) {
    int initialQuantity = int.parse(row.quantity);
    int minQuantity = isQuantitySquared ? (initialQuantity * 0.4).toInt() : 0;
    Duration duration = const Duration(milliseconds: 600);
    int step = initialQuantity ~/ 10;

    Timer.periodic(duration, (timer) {
      setState(() {
        int currentQuantity = int.parse(row.quantity);

        if (currentQuantity > minQuantity) {
          row.quantity = (currentQuantity - step).toString();
          if (isQuantitySquared && int.parse(row.quantity) <= minQuantity) {
            row.quantity = minQuantity.toString();
            status = "Partially Executed";
            timer.cancel();

            table.data.insert(
                0, RowData(price: "654.52", quantity: "600", orders: "4"));
            table.data.removeLast();

            highlightedRowData = table.data.first;
          }
        } else {
          row.quantity = minQuantity.toString();
          status = isQuantitySquared ? "Partially Executed" : "Executed";
          timer.cancel();
        }
      });
    });
  }

  void showAnimation(HorizontalLineModel model) {
    for (ReelRangeResponse reelRangeResponse in model.responseRange) {
      setState(() {
        model.correctResponseLayer.add(RangeLayer(
            value1: max(reelRangeResponse.max, reelRangeResponse.min),
            value2: min(reelRangeResponse.max, reelRangeResponse.min),
            color: const Color.fromARGB(100, 50, 100, 29)));
      });
    }
    int correctCount = 0;
    for (ReelRangeResponse reelRangeResponse in model.responseRange) {
      for (var element in model.userResponse) {
        if (min(reelRangeResponse.min, reelRangeResponse.max) <=
                element.value &&
            max(reelRangeResponse.min, reelRangeResponse.max) >=
                element.value) {
          setState(() {
            correctCount++;
          });
        }
      }
    }

    if (correctCount == model.userResponse.length) {
      setState(() {
        model.isCorrect = true;
      });
    } else {
      setState(() {
        model.isCorrect = false;
      });
    }
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => BottomSheetWidget(
            isCorrect: model.isCorrect,
            model: model.explanationV1,
            onNextClick: () {
              moveToNextStep();
              setState(() {
                model.isCorrect = false;
                model.correctResponseLayer = [];
                model.userResponse = [];
              });
            }));
  }

  void takeToCorrectOffsets(TrendLineModel model) {
    if (model.pointLabels.isNotEmpty) {
      for (int i = 0; i < model.pointLabels.length; i++) {
        model.pointLabelCorrectResponse.add(UserPointLabelResponse(
            model.pointLabels[i].tag,
            model.pointLabels[i].start,
            model.pointLabels[i].end,
            Colors.green));

        if (model.pointLabelResponse[i].pos >=
                model.pointLabelCorrectResponse[i].pos - 0.5 &&
            model.pointLabelResponse[i].pos <=
                model.pointLabelCorrectResponse[i].pos + 0.5 &&
            model.pointLabelResponse[i].value >=
                model.pointLabelCorrectResponse[i].value - 10 &&
            model.pointLabelResponse[i].value <=
                model.pointLabelCorrectResponse[i].value + 10) {
          setState(() {
            model.isCorrect = true;
          });
        }
      }
    }
    if (model.lineOffsets.isNotEmpty) {
      for (int i = 0; i < model.lineOffsets.length; i++) {
        List<UserLineResponse> userLineResponses = [];

        userLineResponses.add(UserLineResponse(
            i.toString(),
            [
              Offset(
                  model.lineOffsets[i][0].start, model.lineOffsets[i][0].end),
              Offset(
                  model.lineOffsets[i][1].start, model.lineOffsets[i][1].end),
            ],
            const Color.fromARGB(100, 50, 100, 29)));

        if (model.lineResponse[i][0].offset[0].dx >=
                model.lineOffsets[i][0].start - 0.5 &&
            model.lineResponse[i][0].offset[0].dx <=
                model.lineOffsets[i][0].start + 0.5 &&
            model.lineResponse[i][0].offset[0].dy >=
                model.lineOffsets[i][0].end - 5 &&
            model.lineResponse[i][0].offset[0].dy <=
                model.lineOffsets[i][0].end + 5) {
          if (model.lineResponse[i][0].offset[1].dy >=
                  model.lineOffsets[i][0].start + 5 &&
              model.lineResponse[i][0].offset[1].dy >=
                  model.lineOffsets[i][0].start - 5) {
            setState(() {
              model.isCorrect = true;
            });
          }
        }
        setState(() {
          model.lineCorrectResponse.add(userLineResponses);
        });
      }
    }

    Future.delayed(const Duration(seconds: 2)).then((val) {
      moveToNextStep();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    final step = widget.model.userStory.steps.firstWhere(
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
                        prompt: uiData.prompt,
                        title: uiData.title,
                        logo: "assets/axis_logo.png");
                  case "MarketDepthTable":
                    return MarketDepthTableWidget(
                      tableAlignment:
                          uiData.tableModel?.tableAlignment ?? "horizontal",
                      tableData: uiData.tableModel?.tableData ?? [],
                      title: uiData.title,
                      highlightedRowData: highlightedRowData,
                    );
                  case "Buttons":
                    return MultipleButtonsWidget(
                      buttonsFormat: uiData.buttonsFormat ?? "horizontal",
                      buttonsData: uiData.buttonsData ?? [],
                      onAction: moveToNextStep,
                    );
                  case "MCQQuestion":
                    return MCQQuestionWidget(
                      title: uiData.title,
                      format: uiData.format ?? "",
                      options: uiData.options ?? [],
                      correctResponse: uiData.correctResponse ?? [],
                      onOptionSelected: (selectedItems) {
                        setState(() {
                          selectedResponses = selectedItems;
                        });
                        setState(() {
                          isAnsweredCorrect = Set.from(selectedItems)
                                  .difference(
                                      Set.from(uiData.correctResponse ?? []))
                                  .isEmpty &&
                              selectedResponses.length ==
                                  (uiData.correctResponse ?? []).length;
                        });
                      },
                    );
                  case "PlainText":
                    return Markdown(
                      data: uiData.prompt,
                      shrinkWrap: true,
                      styleSheet:
                          MarkdownStyleSheet(h1Align: WrapAlignment.center),
                    );
                  case "HorizontalLineChart":
                    return SizedBox(
                        height: 350,
                        child: TradeableChart(model: uiData.chart!));
                  case "VolumeChart":
                    return VolumeBarChart(candles: uiData.candles ?? []);
                  case "VolumePriceSlider":
                    return VolumePriceSlider(
                        title: uiData.title,
                        prompt: uiData.prompt,
                        textData: uiData.volumePriceTextData ?? [],
                        candles: uiData.candles ?? [],
                        onSliderChanged: (sliderVal) {});
                  case "TradeInfo":
                    return TradeInfo(
                        title: uiData.title,
                        limitPrice: staticHighlightedRowData?.price ?? '',
                        quantity: staticHighlightedRowData?.quantity ?? '',
                        status: status);
                  case "ImageWidget":
                    return Image.network(uiData.imageUrl!,
                        fit: BoxFit.cover,
                        height: double.parse(uiData.height ?? "150"));
                  case "CustomMCQWidget":
                    return CustomMCQWidget(
                      format: uiData.format ?? "",
                      question: uiData.prompt,
                      ui: uiData.uiWidgets ?? [],
                      onOptionSelected: (selectedOption) {
                        setState(() {
                          selectedResponses = [selectedOption.prompt];
                          isAnsweredCorrect = Set.from(selectedResponses)
                                  .difference(
                                      Set.from(uiData.correctResponse ?? []))
                                  .isEmpty &&
                              selectedResponses.length ==
                                  (uiData.correctResponse ?? []).length;
                        });
                      },
                    );
                  case "CouponWidget":
                    return TicketCouponWidget(model: uiData.ticketCouponModel!);
                  case "SizedBox":
                    return SizedBox(
                        height: double.parse(uiData.height ?? "0"),
                        width: uiData.width != null && uiData.width!.isNotEmpty
                            ? double.parse(uiData.width!)
                            : double.infinity);
                  case "MCQQuestionV1":
                    return MCQQuestionWidgetV1(
                      title: uiData.title,
                      format: uiData.format ?? "",
                      options: uiData.options ?? [],
                      correctResponse: uiData.correctResponse ?? [],
                      onOptionSelected: (selectedItems) {
                        setState(() {
                          selectedResponses = selectedItems;
                        });
                        setState(() {
                          isAnsweredCorrect = Set.from(selectedItems)
                                  .difference(
                                      Set.from(uiData.correctResponse ?? []))
                                  .isEmpty &&
                              selectedResponses.length ==
                                  (uiData.correctResponse ?? []).length;
                        });
                      },
                    );
                  case "OptionChain":
                    return OptionsDataWidget(
                      data: uiData.optionsData!.options,
                      onRowSelected: (entry, quan) {
                        setState(() {
                          selectedOptionEntry = entry;
                          quantity = quan;
                        });
                        moveToNextStep();
                      },
                      selectedOptionEntry: selectedOptionEntry,
                    );
                  case "OptionTradeSheet":
                    return OptionTradeSheet(
                        limitPrice:
                            selectedOptionEntry!.premium.toStringAsFixed(2),
                        quantity: quantity.toString());

                  case "OrderStatusWidget":
                    return OrderStatusWidget(
                        limitPrice:
                            selectedOptionEntry!.premium.toStringAsFixed(2),
                        quantity: quantity.toString(),
                        model: step.ui
                            .firstWhere((widget) =>
                                widget.widget == "HorizontalLineChart")
                            .chart!);
                  case "TrendLineChart":
                    return SizedBox(
                        height: 400,
                        child: TrendLineChart(model: uiData.trendLineModelV1!));
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
                    confirmOrder(false);
                    break;
                  case "showBottomSheet":
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final step = widget.model.userStory.steps.firstWhere(
                            (step) => step.stepId == currentStepId,
                          );

                          final uiWithTableModel = step.ui.firstWhere(
                            (ui) => ui.tableModel != null,
                          );

                          final tableModel = uiWithTableModel.tableModel!;

                          return TradeSheet(
                            tableRowDataMap: {
                              0: tableModel.tableData!.first.data
                            },
                            onRowDataSelected: (RowData data) {
                              setState(() {
                                highlightedRowData = data;
                              });
                            },
                            moveNext: () {
                              confirmOrder(
                                  tableModel.isQuantitySquared ?? false);
                            },
                            isQuantitySquared:
                                tableModel.isQuantitySquared ?? false,
                          );
                        });
                    break;
                  case "submitResponse":
                    showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context) => BottomSheetWidget(
                            isCorrect: isAnsweredCorrect ?? false,
                            model: step.explanationV1,
                            onNextClick: () {
                              moveToNextStep();
                            }));
                    break;
                  case "showCorrectHorizontalLines":
                    showAnimation(step.ui
                        .firstWhere((a) => a.widget == "HorizontalLineChart")
                        .chart!);
                  case "moveToNextStep":
                    moveToNextStep();
                    break;
                  case "submitTrendLineWidget":
                    takeToCorrectOffsets(step.ui
                        .firstWhere((a) => a.widget == "TrendLineChart")
                        .trendLineModelV1!);
                  case "showSummaryBottomSheet":
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Markdown(
                                    data: step.ui.last.prompt,
                                    shrinkWrap: true),
                                const SizedBox(height: 10),
                                ButtonWidget(
                                    color: colors.primary,
                                    btnContent: "Next",
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      widget.onNextClick();
                                    }),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        });
                }
              }
            },
          ),
        ),
      ],
    );
  }

  List<RowData> getFirstTableRowData(List<TableData> tableDataList) {
    return tableDataList.isNotEmpty ? tableDataList.first.data : [];
  }
}
