import 'package:chips_choice/chips_choice.dart';
import 'package:device_frame/device_frame.dart';
import 'package:example/data_model/atm_itm_dropdown_model.dart';
import 'package:example/data_model/bucket_containerv1_model.dart';
import 'package:example/data_model/candle_body_select_model.dart';
import 'package:example/data_model/candle_part_match_model.dart';
import 'package:example/data_model/candle_select_question_model.dart';
import 'package:example/data_model/content_preview_model.dart';
import 'package:example/data_model/educorner_model_v1.dart';
import 'package:example/data_model/en1_model.dart';
import 'package:example/data_model/expandable_edutile_model.dart';
import 'package:example/data_model/horizontal_line_model.dart';
import 'package:example/data_model/ladder_data_model.dart';
import 'package:example/data_model/mcq_candle_image_model.dart';
import 'package:example/data_model/mcq_static_model.dart';
import 'package:example/data_model/options_educorner_model.dart';
import 'package:example/data_model/options_scenario_model.dart';
import 'package:example/data_model/video_educorner_model.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class WidgetChips {
  final String label;
  final Widget widget;

  WidgetChips({required this.label, required this.widget});
}

class TradeableWidgetDemoPage extends StatefulWidget {
  const TradeableWidgetDemoPage({super.key});

  @override
  State<TradeableWidgetDemoPage> createState() =>
      _TradeableWidgetDemoPageState();
}

class _TradeableWidgetDemoPageState extends State<TradeableWidgetDemoPage> {
  int tag = 1;
  List<WidgetChips> widgetOptions = [
    WidgetChips(
        label: "Youtube Video Education Corner",
        widget: VideoEduCorner(
            model: VideoEduCornerModel.fromJson(videoEducornerModel))),
    WidgetChips(
        label: "Market Value Selector",
        widget: ATMWidget(
          model: ATMWidgetModel.fromJson(atmItmDropdownModel),
        )),
    WidgetChips(
      label: "Expandable EduCorner",
      widget: ExpandableEduTileMain(
          model: ExpandableEduTileModel.fromJson(expandableEduTileModelData)),
    ),
    WidgetChips(
      label: "Candle Part Identifier",
      widget: CandleBodySelect(
          model: CandlePartSelectModel.fromJson(candleBodySelectModelData)),
    ),
    WidgetChips(
        label: "Options Wall",
        widget: LadderWidgetMain(
            ladderModel: LadderModel.fromJson(ladderQuestionData))),
    WidgetChips(
        label: "Candle Part Identifier V2",
        widget: CandlePartMatchLink(
            model: CandleMatchThePairModel.fromJson(candlePartMatchModelData))),
    WidgetChips(
        label: "Match the pair",
        widget: EN1(model: EN1Model.fromJson(en1DataModel))),
    WidgetChips(
        label: "Candle Selection Tool",
        widget: CandleSelectQuestion(
            model:
                CandleSelectModel.fromJson(candleSelectQuestionStaticModel))),
    WidgetChips(
        label: "MCQ Question",
        widget: MCQQuestion(model: MCQModel.fromJson(mcqStaticModel))),
    WidgetChips(
        label: "Horizontal line Question",
        widget: HorizontalLineQuestion(
            model: HorizontalLineModel.fromJson(horizontalLineModel))),
    WidgetChips(
        label: "MCQ Question",
        widget: MCQCandleQuestion(
            model: MCQCandleModel.fromJson(mcqCandleImageModel))),
    WidgetChips(
        label: "FNO Scenario Page",
        widget: DragAndDropMatch(
            model: LadderModel.fromJson(optionsScenarioModel))),
    WidgetChips(
        label: "Categorisation Widget",
        widget: BucketContainerV1(
            model: BucketContainerModel.fromJson(bucketContainerV1Model))),
    WidgetChips(
        label: "Edu Corner V1",
        widget: EduCornerV1(model: EduCornerModel.fromJson(educornerV1Model))),
    WidgetChips(
        label: "EduCorner V2",
        widget: MarkdownPreviewWidget(
            model: MarkdownPreviewModel.fromJson(contentPreviewModel))),
    WidgetChips(
        label: "Options EduCorner",
        widget: OptionEduCorner(
            model: OptionsEduCornerModel.fromJson(optionsEducornerModel))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
            // print(constraints.maxHeight);
            // print(constraints.maxWidth);
            // double phoneHeight = constraints.maxHeight < 860
            //     ? 860 * 0.7
            //     : constraints.maxHeight * 0.7;
            //double phoneHeight = 860 * 0.7;
            //print("height : ${constraints.maxHeight} , phone : $phoneHeight");
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.3 < 550
                      ? 550
                      : constraints.maxWidth * 0.3,
                  child: renderWidgets(),
                ),
                Expanded(child: renderPreview())
              ],
            );
          }),
        ),
      )),
    );
  }

  Widget renderWidgets() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Widgets",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ChipsChoice<int>.single(
            choiceCheckmark: true,
            value: tag,
            onChanged: (val) => setState(() => tag = val),
            choiceItems: C2Choice.listFrom<int, String>(
              source: widgetOptions.map((val) => val.label).toList(),
              value: (i, v) => i,
              label: (i, v) => v,
            ),
            choiceStyle: C2ChipStyle.toned(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            wrapped: true,
          ),
        ],
      ),
    );
  }

  Widget renderPreview() {
    double phoneHeight = 860 * 0.7;
    return Column(
      children: [
        const Text(
          "Preview",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: DeviceFrame(
            device: DeviceInfo.genericPhone(
              platform: TargetPlatform.android,
              name: 'Medium',
              id: 'medium',
              screenSize: Size(phoneHeight * (9 / 16), phoneHeight),
              safeAreas: const EdgeInsets.only(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
              ),
              rotatedSafeAreas: const EdgeInsets.only(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
              ),
            ),
            isFrameVisible: true,
            orientation: Orientation.portrait,
            screen: Builder(
              builder: (deviceContext) => MaterialApp(
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: Brightness.light,
                  ),
                  useMaterial3: true,
                ),
                home: Scaffold(
                  body: SafeArea(
                    child: widgetOptions[tag].widget,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
