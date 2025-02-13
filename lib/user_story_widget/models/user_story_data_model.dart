import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/contracts_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/custom_buttons_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/custom_slider_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/greeks_explainer_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/option_chain_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/table_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/ticket_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/volume_price_text_data_model.dart';
import 'package:tradeable_learn_widget/utils/explanation_model.dart';

class UserStoryDataModel {
  String id;
  String name;
  String description;
  List<StepData> steps;

  UserStoryDataModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.steps});

  factory UserStoryDataModel.fromJson(Map<String, dynamic> json) {
    return UserStoryDataModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        steps: (json['steps'] as List<dynamic>)
            .map((step) => StepData.fromJson(step))
            .toList());
  }
}

class StepData {
  String stepId;
  List<UiData> ui;
  bool isActionNeeded;
  ExplanationV1? explanationV1;

  StepData(
      {required this.stepId,
      required this.ui,
      required this.isActionNeeded,
      this.explanationV1});

  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
        stepId: json['stepId'] ?? '',
        ui: (json['ui'] as List<dynamic>)
            .map((uiItem) => UiData.fromJson(uiItem))
            .toList(),
        isActionNeeded: json["isActionNeeded"],
        explanationV1: json["explaination"] != null
            ? ExplanationV1(
                forCorrect: (json["explaination"]["forCorrect"]
                        as List<dynamic>?)
                    ?.map(
                        (e) => ExplainerV1.fromJson(e as Map<String, dynamic>))
                    .toList(),
                forIncorrect: (json["explaination"]["forIncorrect"]
                        as List<dynamic>?)
                    ?.map(
                        (e) => ExplainerV1.fromJson(e as Map<String, dynamic>))
                    .toList(),
              )
            : ExplanationV1(
                forCorrect: [
                  ExplainerV1(
                    title: "Correct",
                    data: "You got it correct",
                    imageUrl: "assets/btmsheet_correct.png",
                  )
                ],
                forIncorrect: [
                  ExplainerV1(
                    title: "Incorrect",
                    data: "You got it incorrect",
                    imageUrl: "assets/btmsheet_incorrect.png",
                  )
                ],
              ));
  }
}

class UiData {
  String widget;
  String title;
  String prompt;
  TableModel? tableModel;
  String? buttonsFormat;
  List<ButtonData>? buttonsData;
  String? format;
  List<String>? options;
  List<String>? correctResponse;
  String? action;
  HorizontalLineModel? chart;
  List<Candle>? candles;
  List<VolumePriceTextData>? volumePriceTextData;
  String? height;
  String? width;
  List<UiData>? uiWidgets;
  TicketCouponModel? ticketCouponModel;
  String? imageUrl;
  OptionData? optionsData;
  TrendLineModel? trendLineModelV1;
  ContractDetailsModel? contractDetailsModel;
  SliderData? sliderDataModel;
  GreeksExplainerModel? greeksExplainerModel;

  UiData(
      {required this.widget,
      required this.title,
      required this.prompt,
      this.tableModel,
      this.buttonsFormat,
      this.buttonsData,
      this.format,
      this.options,
      this.correctResponse,
      this.action,
      this.chart,
      this.candles,
      this.volumePriceTextData,
      this.height,
      this.width,
      this.uiWidgets,
      this.ticketCouponModel,
      this.imageUrl,
      this.optionsData,
      this.trendLineModelV1,
      this.contractDetailsModel,
      this.sliderDataModel,
      this.greeksExplainerModel});

  factory UiData.fromJson(Map<String, dynamic> json) {
    return UiData(
        widget: json['widget'] ?? '',
        title: json['title'] ?? '',
        prompt: json['prompt'] ?? '',
        tableModel: json["tableData"] != null
            ? TableModel.fromJson(json["tableData"])
            : null,
        buttonsFormat: json['buttonsFormat'],
        buttonsData: json['buttonsData'] != null
            ? (json['buttonsData'] as List<dynamic>)
                .map((buttonItem) => ButtonData.fromJson(buttonItem))
                .toList()
            : null,
        format: json['format'],
        options:
            json['options'] != null ? List<String>.from(json['options']) : null,
        correctResponse: json['correctResponse'] != null
            ? List<String>.from(json['correctResponse'])
            : null,
        action: json['action'] ?? '',
        chart: json["chart"] != null
            ? HorizontalLineModel.fromJson(json["chart"])
            : null,
        candles: json["candles"] != null
            ? ((json["candles"]) as List)
                .map((x) => Candle.fromJson(x))
                .toList()
            : [],
        volumePriceTextData: json["textData"] != null
            ? (json['textData'] as List<dynamic>)
                .map((buttonItem) => VolumePriceTextData.fromJson(buttonItem))
                .toList()
            : null,
        height: json['height'] ?? '',
        width: json['width'] ?? '',
        uiWidgets: json['ui'] != null
            ? (json['ui'] as List<dynamic>)
                .map((uiItem) => UiData.fromJson(uiItem))
                .toList()
            : null,
        ticketCouponModel: json["ticketModel"] != null
            ? TicketCouponModel.fromJson(json["ticketModel"])
            : null,
        imageUrl: json["imageUrl"] ?? "",
        optionsData: json["optionData"] != null
            ? OptionData.fromJson(json["optionData"])
            : null,
        trendLineModelV1: json["trendlineChart"] != null
            ? TrendLineModel.fromJson(json["trendlineChart"])
            : null,
        contractDetailsModel: json["contractsInfo"] != null
            ? ContractDetailsModel.fromJson(json["contractsInfo"])
            : null,
        sliderDataModel: json["sliderData"] != null
            ? SliderData.fromJson(json["sliderData"])
            : null,
        greeksExplainerModel: json["greeksExplainerModel"] != null
            ? GreeksExplainerModel.fromJson(json["greeksExplainerModel"])
            : null);
  }
}
