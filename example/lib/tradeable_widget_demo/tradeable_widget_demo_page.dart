import 'package:chips_choice/chips_choice.dart';
import 'package:device_frame/device_frame.dart';
import 'package:example/data_model/atm_itm_dropdown_model.dart';
import 'package:example/data_model/candle_body_select_model.dart';
import 'package:example/data_model/expandable_edutile_model.dart';
import 'package:example/data_model/video_educorner_model.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/atm_itm_dropdown_widget/atm_itm_dropdown_data_model.dart';
import 'package:tradeable_learn_widget/atm_itm_dropdown_widget/atm_itm_dropdown_widget_main.dart';
import 'package:tradeable_learn_widget/candle_body_select/candle_body_select.dart';
import 'package:tradeable_learn_widget/candle_body_select/candle_body_select_model.dart';
import 'package:tradeable_learn_widget/expandable_edutile_widget/expandable_edutile_main.dart';
import 'package:tradeable_learn_widget/expandable_edutile_widget/expandable_edutile_model.dart';
import 'package:tradeable_learn_widget/video_educorner/video_educorner.dart';
import 'package:tradeable_learn_widget/video_educorner/video_educorner_model.dart';

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
        widget:
            VideoEduCorner(model: VideoEduCornerModel(videoEducornerModel))),
    WidgetChips(
        label: "AtmDropdownWidgetPage",
        widget: ATMWidget(
          model: ATMWidgetModel(atmItmDropdownModel),
        )),
    WidgetChips(
      label: "ExpandableEduCornerPage",
      widget: ExpandableEduTileMain(
          model: ExpandableEduTileModel(expandableEduTileModelData)),
    ),
    WidgetChips(
      label: "CandleBodySelect",
      widget: CandleBodySelect(
          model: CandlePartSelectModel(candleBodySelectModelData)),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
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
