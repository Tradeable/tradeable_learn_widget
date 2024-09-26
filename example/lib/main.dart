import 'package:example/data_model/atm_itm_dropdown_model.dart';
import 'package:example/data_model/candle_body_select_model.dart';
import 'package:example/data_model/candle_part_match_model.dart';
import 'package:example/data_model/candle_select_question_model.dart';
import 'package:example/data_model/en1_model.dart';
import 'package:example/data_model/expandable_edutile_model.dart';
import 'package:example/data_model/ladder_data_model.dart';
import 'package:example/data_model/mcq_static_model.dart';
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
      home: const MyHomePage(),
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

class LadderWidgetPage extends StatelessWidget {
  const LadderWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: LadderWidgetMain(
        ladderModel: LadderModel(ladderQuestionData),
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
        model: ATMWidgetModel(atmItmDropdownModel),
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
          model: ExpandableEduTileModel(expandableEduTileModelData)),
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
          model: CandlePartSelectModel(candleBodySelectModelData)),
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
          model: CandleMatchThePairModel(candlePartMatchModelData)),
    );
  }
}

class EN1Page extends StatelessWidget {
  const EN1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: EN1(model: EN1Model(en1DataModel)),
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
          model: CandleSelectModel(candleSelectQuestionStaticModel)),
    );
  }
}

class MCQQuestionPage extends StatelessWidget {
  const MCQQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAppBar(
      title: "Problem",
      body: MCQQuestion(model: MCQModel(mcqStaticModel)),
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
