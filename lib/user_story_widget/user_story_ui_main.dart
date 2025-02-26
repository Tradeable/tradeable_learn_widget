import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/reel_range_response.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/range_layer/range_layer.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/option_chain_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/table_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/ticket_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/user_story_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/contracts_info_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_buttons.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_mcq_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/animated_text_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/custom_slider_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/delta_option_chain.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/greeks_explainer_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/market_depth_user_table.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/mcq_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/mcq_widget_v1.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/option_chain_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/option_trade_sheet.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/order_status_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/plain_text_with_border.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/rr_chart.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/ticket_coupon_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_form_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_info.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_sheet.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/horizontal_line_chart.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_taker_form.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trend_line_chart.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/volume_chart.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/volume_price_slider.dart';
import 'package:tradeable_learn_widget/utils/animated_number.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_simulation_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

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
  UiData? selectedTicket;
  List<TradeFormModel> tradeFormModel = [];
  String? delta;

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
              duration: const Duration(milliseconds: 0),
              curve: Curves.easeInOut)
          .then((_) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 0), curve: Curves.easeInOut);
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
        currentIndex < widget.model.userStory.steps.length) {
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
    final textStyles = Theme.of(context).customTextStyles;

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
                      physics: const NeverScrollableScrollPhysics(),
                      styleSheet: MarkdownStyleSheet(
                          h1Align: WrapAlignment.center,
                          p: textStyles.smallNormal.copyWith(fontSize: 16)),
                    );
                  case "HorizontalLineChart":
                    return Column(
                      children: [
                        SizedBox(
                            height: 350,
                            child: HorizontalLineChart(model: uiData.chart!)),
                        const ChartSimulationWidget()
                      ],
                    );
                  case "VolumeChart":
                    return VolumeBarChart(candles: uiData.candles ?? []);
                  case "VolumePriceSlider":
                    return VolumePriceSlider(
                        title: uiData.title,
                        prompt: uiData.prompt,
                        textData: uiData.volumePriceTextData ?? [],
                        candles: uiData.candles ?? [],
                        onSliderChanged: (sliderVal) {
                          addCandles(step, sliderVal, uiData);
                        });
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
                          if (selectedOption.widget == "CouponWidget") {
                            selectedTicket = selectedOption;
                          }
                        });
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
                      selectedItem: selectedTicket,
                    );
                  case "CouponWidget":
                    if (selectedTicket != null) {
                      selectedTicket?.ticketCouponModel = TicketCouponModel(
                        title: selectedTicket!.ticketCouponModel!.title,
                        color: selectedTicket!.ticketCouponModel!.color,
                        infoModel: List.from(
                            uiData.ticketCouponModel!.infoModel), // Deep copy
                      );
                    }

                    return TicketCouponWidget(
                      model: selectedTicket?.ticketCouponModel ??
                          uiData.ticketCouponModel!,
                    );

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
                      data: uiData.optionsData!,
                      onRowSelected: (entry, quan) {
                        setState(() {
                          selectedOptionEntry = entry;
                          quantity = quan;
                        });
                        updateTrendFormModel();
                        updateLtps();
                      },
                      selectedOptionEntry: selectedOptionEntry,
                    );
                  case "DeltaOptionChainWidget":
                    return DeltaOptionChainWidget(
                      data: uiData.optionsData!,
                      onRowSelected: (entry, quan) {
                        setState(() {
                          selectedOptionEntry = entry;
                          quantity = quan;
                        });
                        updateTrendFormModel();
                        updateLtps();
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
                    return Column(
                      children: [
                        SizedBox(
                            height: 400,
                            child: TrendLineChart(
                                model: uiData.trendLineModelV1!)),
                        const ChartSimulationWidget()
                      ],
                    );
                  case "ContractsInfo":
                    return ContractsInfoWidget(
                        model: uiData.contractDetailsModel!,
                        moveToNextStep: () {
                          setState(() {
                            step.isActionNeeded = false;
                          });
                        });
                  case "CustomSlider":
                    return CustomSliderWidget(
                        sliderData: uiData.sliderDataModel!);
                  case "GreeksExplainerWidget":
                    return GreeksExplainerWidget(
                      model: uiData.greeksExplainerModel!,
                      moveToNextStep: () {
                        setState(() {
                          step.isActionNeeded = false;
                        });
                      },
                    );
                  case "RRChart":
                    return RRChart(
                      model: uiData.rrModel!,
                      enableNext: () {
                        setState(() {
                          step.isActionNeeded = false;
                        });
                      },
                      tradeFormModel: tradeFormModel,
                      scrollToBottom: () {
                        setState(() {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 0),
                              curve: Curves.easeInOut);
                        });
                      },
                    );
                  case "TradeFormWidget":
                    return Column(
                      children: tradeFormModel
                          .map((model) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: TradeFormWidget(tradeFormModel: model),
                              ))
                          .toList(),
                    );
                  case "DeltaWidget":
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Delta: ", style: textStyles.largeBold),
                        const SizedBox(width: 6),
                        AnimatedNumber(value: delta ?? "0")
                      ],
                    );
                  case "PlainTextWithBorder":
                    return PlainTextWithBorder(
                        title: uiData.title, prompt: uiData.prompt);
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
                    break;
                  case "moveToNextStep":
                    moveToNextStep();
                    break;
                  case "submitTrendLineWidget":
                    takeToCorrectOffsets(step.ui
                        .firstWhere((a) => a.widget == "TrendLineChart")
                        .trendLineModelV1!);
                    break;
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
                    break;
                  case "setupOrderBottomSheet":
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final rrModel = step.ui
                              .firstWhere((w) => w.widget == "RRChart")
                              .rrModel!;
                          OrderType getUnlockedOrderType() {
                            for (var tradeType
                                in rrModel.tradeTypeModel ?? []) {
                              for (var executionType
                                  in tradeType.executionTypes) {
                                for (var orderType
                                    in executionType.orderTypes) {
                                  if (!orderType.isLocked) {
                                    return orderType.orderType;
                                  }
                                }
                              }
                            }
                            return OrderType.market;
                          }

                          return TradeTakerForm(
                            model: TradeFormModel(
                                target:
                                    rrModel.rrLayer.target.toStringAsFixed(2),
                                stopLoss:
                                    rrModel.rrLayer.stoploss.toStringAsFixed(2),
                                quantity: 0,
                                isNse: true,
                                isSell: false,
                                tradeType: TradeType.intraday,
                                orderType: getUnlockedOrderType(),
                                isCallTrade: true),
                            tradeFormModel: (tf) {
                              setState(() {
                                tradeFormModel.add(tf);
                              });
                              loadCandlesTillEnd();
                            },
                            tradeTypeModel: rrModel.tradeTypeModel ?? [],
                          );
                        });
                    break;
                  case "executeTrades":
                    updateLtps();
                    break;
                  case "submitRRQuestion":
                    submitRRQuestion();
                    break;
                  case "calculateDelta":
                    calculateDeltaValue();
                    break;
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

  void addCandles(StepData step, int sliderVal, UiData uiData) {
    setState(() {
      List<ui.Candle> uiCandles = step.ui
          .where((widget) => widget.widget == "HorizontalLineChart")
          .first
          .chart!
          .uiCandles;

      uiCandles.removeWhere((candle) {
        int? id = candle.candleId;
        return id >= uiData.candles!.length;
      });

      if (sliderVal == 2) {
        double basePrice = 750;
        for (int i = 1; i <= 7; i++) {
          bool isGreen = i % 2 == 1;
          double open = basePrice + (i * 5);
          double close = isGreen ? open + (i * 5) : open - 5;
          double high = close + 5;
          double low = open - (i * 5);

          uiCandles.add(ui.Candle(
            candleId: (uiData.candles!.length - 1 + i),
            open: open,
            high: high,
            low: low,
            close: close,
            dateTime: DateTime.now().add(Duration(minutes: i)),
            volume: 80 + (i * 10),
          ));
        }
      } else if (sliderVal == 0) {
        double basePrice = 775;
        for (int i = 1; i <= 7; i++) {
          bool isRed = i % 2 == 1;
          double open = basePrice - (i * 5);
          double close = isRed ? open - (5 * i) : open + (i * 5);
          double high = open + (2 * i);
          double low = close;

          uiCandles.add(ui.Candle(
            candleId: (uiData.candles!.length - 1 + i),
            open: open,
            high: high,
            low: low,
            close: close,
            dateTime: DateTime.now().add(Duration(minutes: i)),
            volume: 80 + (i * 10), // Increased volume
          ));
        }
      }
      step.ui
          .where((widget) => widget.widget == "HorizontalLineChart")
          .first
          .chart!
          .uiCandles = uiCandles;
    });
  }

  void loadCandlesTillEnd() async {
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

    final step = widget.model.userStory.steps
        .firstWhere((step) => step.stepId == currentStepId);
    final chart = step.ui.firstWhere((w) => w.widget == "RRChart").rrModel!;
    setState(() {
      chart.rrLayer.target = double.parse(tradeFormModel.first.target);
      chart.rrLayer.stoploss = double.parse(tradeFormModel.first.stopLoss);
    });

    List<ui.Candle> allCandles = chart.candles
        .map((e) => ui.Candle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList();

    chart.uiCandles.addAll(allCandles
        .takeWhile((c) => c.dateTime.millisecondsSinceEpoch <= chart.atTime));

    tradeFormModel.first.avgPrice =
        (chart.uiCandles.first.close).toStringAsFixed(2);

    setState(() {});

    for (final candle in allCandles
        .skipWhile((c) => c.dateTime.millisecondsSinceEpoch <= chart.atTime)) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        tradeFormModel.first.ltp = candle.close.toStringAsFixed(2);
      });
    }
  }

  void updateTrendFormModel() async {
    setState(() {
      tradeFormModel.add(TradeFormModel(
          target: "-",
          stopLoss: "-",
          quantity: int.parse(quantity ?? "0"),
          isNse: true,
          isSell: !selectedOptionEntry!.isBuy,
          tradeType: TradeType.intraday,
          ltp: "-",
          avgPrice: "-",
          orderType: OrderType.market,
          isCallTrade: selectedOptionEntry!.isCallTrade,
          isDeltaBeingCalculated: true));
    });
  }

  void updateLtps() async {
    moveToNextStep();
    final step = widget.model.userStory.steps
        .firstWhere((step) => step.stepId == currentStepId);

    TrendLineModel? chart;

    for (var ui in step.ui) {
      if (ui.widget == "TrendLineChart") {
        chart = ui.trendLineModelV1;
        break;
      }
    }

    if (chart != null) {
      List<ui.Candle> allCandles = chart.candles
          .map((e) => ui.Candle(
                candleId: e.candleNum,
                open: e.open,
                high: e.high,
                low: e.low,
                close: e.close,
                dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
                volume: e.vol.round(),
              ))
          .toList();

      for (TradeFormModel trade in tradeFormModel) {
        trade.avgPrice = allCandles.first.close.toStringAsFixed(2);
        trade.ltp = allCandles.last.close.toStringAsFixed(2);
      }

      setState(() {});

      for (final candle in allCandles.skipWhile(
          (c) => c.dateTime.millisecondsSinceEpoch <= chart!.atTime)) {
        await Future.delayed(const Duration(milliseconds: 100));

        setState(() {
          for (var trade in tradeFormModel) {
            trade.ltp = candle.close.toStringAsFixed(2);
          }
        });
      }
    }
  }

  void submitRRQuestion() {
    final step = widget.model.userStory.steps
        .firstWhere((step) => step.stepId == currentStepId);
    final chart = step.ui.firstWhere((w) => w.widget == "RRChart").rrModel!;
    double target = chart.rrLayer.target;
    double stoploss = chart.rrLayer.stoploss;
    moveToNextStep();

    final nextStep = widget.model.userStory.steps
        .firstWhere((step) => step.stepId == currentStepId);
    final nextChart =
        nextStep.ui.firstWhere((w) => w.widget == "RRChart").rrModel!;

    setState(() {
      nextChart.rrLayer.target = target;
      nextChart.rrLayer.stoploss = stoploss;
    });
  }

  void calculateDeltaValue() {
    final step = widget.model.userStory.steps
        .firstWhere((step) => step.stepId == currentStepId);
    final optionData = step.ui
        .firstWhere((w) => w.widget == "DeltaOptionChainWidget")
        .optionsData!;
    final allStrikes = [
      ...optionData.options.call.entries.map((e) => e.strike)
    ];
    final atmStrike = allStrikes[allStrikes.length ~/ 2];

    if (selectedOptionEntry == null) {
      return;
    }

    double deltaValue = 0.0;
    final isCall = selectedOptionEntry!.premium ==
        optionData.options.call.entries
            .firstWhere(
              (e) => e.strike == selectedOptionEntry!.strike,
            )
            .premium;

    if (isCall) {
      if (selectedOptionEntry!.strike < atmStrike) {
        deltaValue = 0.70 +
            (0.30 * ((atmStrike - selectedOptionEntry!.strike) / atmStrike));
        deltaValue = deltaValue.clamp(0.70, 1.00);
      } else if (selectedOptionEntry!.strike > atmStrike) {
        deltaValue = 0.30 *
            (1 - ((selectedOptionEntry!.strike - atmStrike) / atmStrike));
        deltaValue = deltaValue.clamp(0.20, 0.30);
      } else {
        deltaValue = 0.50;
      }
    } else {
      if (selectedOptionEntry!.strike > atmStrike) {
        deltaValue = -(0.70 +
            (0.30 * ((selectedOptionEntry!.strike - atmStrike) / atmStrike)));
        deltaValue = deltaValue.clamp(-1.00, -0.70);
      } else if (selectedOptionEntry!.strike < atmStrike) {
        deltaValue = -(0.30 *
            (1 - ((atmStrike - selectedOptionEntry!.strike) / atmStrike)));
        deltaValue = deltaValue.clamp(-0.30, -0.20);
      } else {
        deltaValue = -0.50;
      }
    }
    setState(() {
      delta = deltaValue.toStringAsFixed(2);
    });

    updateLtps();
  }
}
