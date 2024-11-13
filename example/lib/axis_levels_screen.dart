import 'dart:async';

import 'package:dio/dio.dart';
import 'package:example/data_model/level_model.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class AxisLevelsScreen extends StatelessWidget {
  const AxisLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyLevelWidget(levelId: 283)));
              },
              child: const Text("Intro to TA")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyLevelWidget(levelId: 284)));
              },
              child: const Text("Support & Resistance")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyLevelWidget(levelId: 286)));
              },
              child: const Text("Greeks")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyLevelWidget(levelId: 287)));
              },
              child: const Text("Trading Fundamentals")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyLevelWidget(levelId: 285)));
              },
              child: const Text("Options"))
        ],
      )),
    );
  }
}

class MyLevelWidget extends StatefulWidget {
  final int levelId;

  const MyLevelWidget({super.key, required this.levelId});

  @override
  State<StatefulWidget> createState() => _MyLevelWidget();
}

class _MyLevelWidget extends State<MyLevelWidget> {
  late Level level;
  bool isLoading = true;
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchLevelById(widget.levelId).then((val) {
      setState(() {
        isLoading = false;
        level = val;
      });
      startIndexUpdater();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startIndexUpdater() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % level.graph!.length;
      });
    });
  }

  Future<Level> fetchLevelById(int levelId) async {
    Response response = await Dio().get(
      "https://dev.api.tradeable.app/v4/learn/level/$levelId",
      // data: {"levelId": levelId},
      options: Options(
        headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiWTNwMFFkWHFQYmVPR2J3MnZuNEJiOEpIOEV2MiIsImlhdCI6MTcxNDk4NTUwOCwiZXhwIjoxNzQ2NTIxNTA4fQ.81vqPGeEItEeL62HXmmBPsN532TMDlhHdKDB6mb7KQI"
        },
      ),
    );
    return Level.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : getViewByType(
                level.graph![currentIndex].model ?? "",
                level.graph![currentIndex].data as Map<String, dynamic>?,
              ),
      ),
    );
  }

  Widget getViewByType(String levelType, Map<String, dynamic>? data) {
    switch (levelType) {
      case "Edu_Corner":
        return EduCornerV1(model: EduCornerModel.fromJson(data));
      case "CA1.1":
        return CandleBodySelect(model: CandlePartSelectModel.fromJson(data));
      case "ladder_question":
        return LadderWidgetMain(ladderModel: LadderModel.fromJson(data));
      case "call_put_atm":
        return ATMWidget(model: ATMWidgetModel.fromJson(data));
      case "expandableEduTileModelData":
        return ExpandableEduTileMain(
            model: ExpandableEduTileModel.fromJson(data));
      case "CA1.2":
        return CandlePartMatchLink(
            model: CandleMatchThePairModel.fromJson(data));
      case "EN1":
        return EN1(model: EN1Model.fromJson(data));
      case "MultipleCandleSelect_STATIC":
      case "MultipleCandleSelect_DYNAMIC":
        return CandleSelectQuestion(model: CandleSelectModel.fromJson(data));
      case "MCQ_STATIC":
      case "MCQ_DYNAMIC":
        return MCQQuestion(model: MCQModel.fromJson(data));
      case "HorizontalLine_STATIC":
      case "HorizontalLine_DYNAMIC":
      case "MultipleHorizontalLine_STATIC":
      case "MultipleHorizontalLine_DYNAMIC":
        return HorizontalLineQuestion(
            model: HorizontalLineModel.fromJson(data));
      case "MCQ_CANDLE":
        return MCQCandleQuestion(model: MCQCandleModel.fromJson(data));
      case "video_educorner":
        return VideoEduCorner(model: VideoEduCornerModel.fromJson(data));
      case "drag_and_drop_match":
      case "fno_scenario_1":
        return DragAndDropMatch(model: LadderModel.fromJson(data));
      case "Bucket_containerv1":
      case "drag_drop_logo":
        return BucketContainerV1(model: BucketContainerModel.fromJson(data));
      case "EduCornerV1":
        return EduCornerV1(model: EduCornerModel.fromJson(data));
      case "content_preview":
        return MarkdownPreviewWidget(
            model: MarkdownPreviewModel.fromJson(data));
      default:
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Text("Unsupported Type: $levelType"),
        );
    }
  }
}
