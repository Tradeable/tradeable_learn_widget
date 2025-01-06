import 'package:example/axis_levels_screen.dart';
import 'package:example/data_model/atm_itm_dropdown_model.dart';
import 'package:example/data_model/bucket_containerv1_model.dart';
import 'package:example/data_model/calender_question_model.dart';
import 'package:example/data_model/candle_body_select_model.dart';
import 'package:example/data_model/candle_formation_v2.dart';
import 'package:example/data_model/candle_part_match_model.dart';
import 'package:example/data_model/candle_select_question_model.dart';
import 'package:example/data_model/content_preview_model.dart';
import 'package:example/data_model/educorner_model_v1.dart';
import 'package:example/data_model/en1_model.dart';
import 'package:example/data_model/expandable_edutile_model.dart';
import 'package:example/data_model/formula_placeholder_model.dart';
import 'package:example/data_model/horizontal_line_model.dart';
import 'package:example/data_model/horizontal_line_model_v1.dart';
import 'package:example/data_model/ladder_data_model.dart';
import 'package:example/data_model/market_depth_model.dart';
import 'package:example/data_model/mcq_candle_image_model.dart';
import 'package:example/data_model/mcq_static_model.dart';
import 'package:example/data_model/multiple_mcq_select_model.dart';
import 'package:example/data_model/options_educorner_model.dart';
import 'package:example/data_model/options_scenario_model.dart';
import 'package:example/data_model/supply_demand_educorner_model.dart';
import 'package:example/data_model/trend_line_model.dart';
import 'package:example/data_model/video_educorner_model.dart';
import 'package:example/home_intermediate_screen.dart';
import 'package:example/tradeable_widget_demo/tradeable_widget_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/market_depth_user_story/market_depth_model.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NavigationButton(
                    text: "Ladder Widget",
                    destination: LadderWidgetPage(),
                  ),
                  const NavigationButton(
                    text: "Dropdown Widget",
                    destination: AtmDropdownWidgetPage(),
                  ),
                  const NavigationButton(
                    text: "ExpandableEduTile Widget",
                    destination: ExpandableEduCornerPage(),
                  ),
                  const NavigationButton(
                    text: "Candle part select Widget",
                    destination: CandleBodySelectPage(),
                  ),
                  const NavigationButton(
                    text: "Candle Match part Widget",
                    destination: CandlePartMatchPage(),
                  ),
                  const NavigationButton(
                    text: "EN1 Match the pair Widget",
                    destination: EN1Page(),
                  ),
                  const NavigationButton(
                    text: "Candle Select Question Widget",
                    destination: CandleSelectQuestionPage(),
                  ),
                  const NavigationButton(
                    text: "MCQ Question Widget",
                    destination: MCQQuestionPage(),
                  ),
                  const NavigationButton(
                    text: "Horizontal line Widget",
                    destination: HorizontalLineQuestionPage(),
                  ),
                  const NavigationButton(
                    text: "MCQ Candle Image Question Widget",
                    destination: MCQCandleImagePage(),
                  ),
                  const NavigationButton(
                    text: "Video Educorner Widget",
                    destination: VideoEducornerPage(),
                  ),
                  const NavigationButton(
                    text: "Fno Scenario Widget",
                    destination: FnoScenarioPage(),
                  ),
                  const NavigationButton(
                    text: "Bucket Widget V1",
                    destination: BucketWidgetPage(),
                  ),
                  const NavigationButton(
                    text: "EduCorner Widget V1",
                    destination: EducornerV1Page(),
                  ),
                  const NavigationButton(
                    text: "Markdown Widget",
                    destination: ContentPreviewPage(),
                  ),
                  const NavigationButton(
                    text: "Options edu",
                    destination: OptionsEduPage(),
                  ),
                  NavigationButton(
                      text: "Calender Question",
                      destination: ScaffoldWithAppBar(
                        title: "Calender Question",
                        body: CalenderQuestion(
                            model: CalenderQuestionModel.fromJson(
                                calenderQuestionModel),
                            onNextClick: () {}),
                      )),
                  NavigationButton(
                      text: "Formula Placeholder Widget",
                      destination: ScaffoldWithAppBar(
                        title: "Formula Placeholder Widget",
                        body: FormulaPlaceholderWidget(
                            model: FormulaPlaceHolderModel.fromJson(
                                formulaPlaceholderDataModel),
                            onNextClick: () {}),
                      )),
                  NavigationButton(
                      text: "Candle Formation V2",
                      destination: ScaffoldWithAppBar(
                        title: "Candle Formation V2",
                        body: CandleFormationV2Main(
                            model: CandleFormationV2Model.fromJson(
                                candleFormationV2),
                            onNextClick: () => {}),
                      )),
                  NavigationButton(
                      text: "Multiple Select MCQ",
                      destination: ScaffoldWithAppBar(
                        title: "Multiple Select MCQ",
                        body: MultipleMCQSelect(
                            model: MultipleMCQModel.fromJson(multipleSelectMCQ),
                            onNextClick: () => {}),
                      )),
                  NavigationButton(
                      text: "Trend Line",
                      destination: ScaffoldWithAppBar(
                        title: "Trend Line",
                        body: TrendLineWidget(
                            model: TrendLineModel.fromJson(trendLineModel),
                            onNextClick: () => {}),
                      )),
                  NavigationButton(
                      text: "Supply Demand Educorner",
                      destination: ScaffoldWithAppBar(
                        title: "Supply Demand Educorner",
                        body: DemandSuplyEduCornerMain(
                            model: DemandSupplyEduCornerModel.fromJson(
                                supplyDemandModel),
                            onNextClick: () {}),
                      )),
                  NavigationButton(
                      text: "Market Depth",
                      destination: ScaffoldWithAppBar(
                          title: "Market Depth",
                          body: MarketDepthUserStoryWidget(
                              model:
                                  MarketDepthModel.fromJson(marketDepthModel),
                              onNextClick: () {}))),
                  NavigationButton(
                      text: "Horizontal Line V1",
                      destination: ScaffoldWithAppBar(
                          title: "Horizontal Line V1",
                          body: HorizontalLineQuestionV1(
                              model: HorizontalLineModelV1.fromJson(
                                  horizontalLineModelV1),
                              onNextClick: () {}))),
                ],
              ),
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
          onNextClick: () {}),
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
        onNextClick: () {},
      ),
    );
  }
}

class AtmDropdownWidgetPage extends StatelessWidget {
  const AtmDropdownWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ATMWidget(
        model: ATMWidgetModel.fromJson(atmItmDropdownModel),
        onNextClick: () {},
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
          model: ExpandableEduTileModel.fromJson(expandableEduTileModelData),
          onNextClick: () {}),
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
          model: CandlePartSelectModel.fromJson(candleBodySelectModelData),
          onNextClick: () {}),
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
          model: CandleMatchThePairModel.fromJson(candlePartMatchModelData),
          onNextClick: () {}),
    );
  }
}

class EN1Page extends StatelessWidget {
  const EN1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: EN1(model: EN1Model.fromJson(en1DataModel), onNextClick: () {}),
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
          model: CandleSelectModel.fromJson(candleSelectQuestionStaticModel),
          onNextClick: () {}),
    );
  }
}

class MCQQuestionPage extends StatelessWidget {
  const MCQQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: MCQQuestion(
          model: MCQModel.fromJson(mcqStaticModel), onNextClick: () {}),
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
          model: HorizontalLineModel.fromJson(horizontalLineModel),
          onNextClick: () {}),
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
          model: MCQCandleModel.fromJson(mcqCandleImageModel),
          onNextClick: () {}),
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
          model: VideoEduCornerModel.fromJson(videoEducornerModel),
          onNextClick: () {}),
    );
  }
}

class FnoScenarioPage extends StatelessWidget {
  const FnoScenarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: DragAndDropMatch(
          model: LadderModel.fromJson(optionsScenarioModel),
          onNextClick: () {}),
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
          model: BucketContainerModel.fromJson(bucketContainerV1Model),
          onNextClick: () {}),
    );
  }
}

class EducornerV1Page extends StatelessWidget {
  const EducornerV1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: EduCornerV1(
          model: EduCornerModel.fromJson(educornerV1Model), onNextClick: () {}),
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
          model: MarkdownPreviewModel.fromJson(contentPreviewModel),
          onNextClick: () {}),
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
