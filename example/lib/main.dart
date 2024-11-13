import 'package:example/axis_levels_screen.dart';
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
import 'package:example/home_intermediate_screen.dart';
import 'package:example/tradeable_widget_demo/tradeable_widget_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: "/homeIntermediate",
      routes: {
        "/": (context) => const TradeableWidgetDemoPage(),
        "/deepak": (context) => const MyHomePage(),
        "/homeIntermediate": (context) => const HomeIntermediateScreen(),
        "/axis_levels": (context) => const AxisLevelsScreen()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavigationButton(
                  text: "Ladder Widget",
                  destination: LadderWidgetPage(),
                ),
                NavigationButton(
                  text: "Dropdown Widget",
                  destination: AtmDropdownWidgetPage(),
                ),
                NavigationButton(
                  text: "ExpandableEduTile Widget",
                  destination: ExpandableEduCornerPage(),
                ),
                NavigationButton(
                  text: "Candle part select Widget",
                  destination: CandleBodySelectPage(),
                ),
                NavigationButton(
                  text: "Candle Match part Widget",
                  destination: CandlePartMatchPage(),
                ),
                NavigationButton(
                  text: "EN1 Match the pair Widget",
                  destination: EN1Page(),
                ),
                NavigationButton(
                  text: "Candle Select Question Widget",
                  destination: CandleSelectQuestionPage(),
                ),
                NavigationButton(
                  text: "MCQ Question Widget",
                  destination: MCQQuestionPage(),
                ),
                NavigationButton(
                  text: "Horizontal line Widget",
                  destination: HorizontalLineQuestionPage(),
                ),
                NavigationButton(
                  text: "MCQ Candle Image Question Widget",
                  destination: MCQCandleImagePage(),
                ),
                NavigationButton(
                  text: "Video Educorner Widget",
                  destination: VideoEducornerPage(),
                ),
                NavigationButton(
                  text: "Fno Scenario Widget",
                  destination: FnoScenarioPage(),
                ),
                NavigationButton(
                  text: "Bucket Widget V1",
                  destination: BucketWidgetPage(),
                ),
                NavigationButton(
                  text: "EduCorner Widget V1",
                  destination: EducornerV1Page(),
                ),
                NavigationButton(
                  text: "Markdown Widget",
                  destination: ContentPreviewPage(),
                ),
                NavigationButton(
                  text: "Options edu ",
                  destination: OptionsEduPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String text;
  final Widget destination;

  const NavigationButton({
    super.key,
    required this.text,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Text(text),
    );
  }
}

class OptionsEduPage extends StatelessWidget {
  const OptionsEduPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: OptionEduCorner(
        model: OptionsEduCornerModel.fromJson(optionsEducornerModel),
      ),
    );
  }
}

class LadderWidgetPage extends StatelessWidget {
  const LadderWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: LadderWidgetMain(
        ladderModel: LadderModel.fromJson(ladderQuestionData),
      ),
    );
  }
}

class AtmDropdownWidgetPage extends StatelessWidget {
  const AtmDropdownWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: ATMWidget(
        model: ATMWidgetModel.fromJson(atmItmDropdownModel),
      ),
    );
  }
}

class ExpandableEduCornerPage extends StatelessWidget {
  const ExpandableEduCornerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: ExpandableEduTileMain(
          model: ExpandableEduTileModel.fromJson(expandableEduTileModelData)),
    );
  }
}

class CandleBodySelectPage extends StatelessWidget {
  const CandleBodySelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: CandleBodySelect(
          model: CandlePartSelectModel.fromJson(candleBodySelectModelData)),
    );
  }
}

class CandlePartMatchPage extends StatelessWidget {
  const CandlePartMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: CandlePartMatchLink(
          model: CandleMatchThePairModel.fromJson(candlePartMatchModelData)),
    );
  }
}

class EN1Page extends StatelessWidget {
  const EN1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: EN1(model: EN1Model.fromJson(en1DataModel)),
    );
  }
}

class CandleSelectQuestionPage extends StatelessWidget {
  const CandleSelectQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: CandleSelectQuestion(
          model: CandleSelectModel.fromJson(candleSelectQuestionStaticModel)),
    );
  }
}

class MCQQuestionPage extends StatelessWidget {
  const MCQQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: MCQQuestion(model: MCQModel.fromJson(mcqStaticModel)),
    );
  }
}

class HorizontalLineQuestionPage extends StatelessWidget {
  const HorizontalLineQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: HorizontalLineQuestion(
          model: HorizontalLineModel.fromJson(horizontalLineModel)),
    );
  }
}

class MCQCandleImagePage extends StatelessWidget {
  const MCQCandleImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: MCQCandleQuestion(
          model: MCQCandleModel.fromJson(mcqCandleImageModel)),
    );
  }
}

class VideoEducornerPage extends StatelessWidget {
  const VideoEducornerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: VideoEduCorner(
          model: VideoEduCornerModel.fromJson(videoEducornerModel)),
    );
  }
}

class FnoScenarioPage extends StatelessWidget {
  const FnoScenarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: DragAndDropMatch(model: LadderModel.fromJson(optionsScenarioModel)),
    );
  }
}

class BucketWidgetPage extends StatelessWidget {
  const BucketWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: BucketContainerV1(
          model: BucketContainerModel.fromJson(bucketContainerV1Model)),
    );
  }
}

class EducornerV1Page extends StatelessWidget {
  const EducornerV1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: EduCornerV1(model: EduCornerModel.fromJson(educornerV1Model)),
    );
  }
}

class ContentPreviewPage extends StatelessWidget {
  const ContentPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: MarkdownPreviewWidget(
          model: MarkdownPreviewModel.fromJson(contentPreviewModel)),
    );
  }
}

class ScaffoldWithAppBar extends StatelessWidget {
  final String title;
  final Widget body;

  const ScaffoldWithAppBar({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: body,
    );
  }
}
