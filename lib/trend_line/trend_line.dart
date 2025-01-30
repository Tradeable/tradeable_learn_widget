import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/fin_chart/models/fin_candle.dart';
import 'package:tradeable_learn_widget/trend_line/models/question_generator.dart';
import 'package:tradeable_learn_widget/trend_line/models/trendline_model.dart';
import 'package:tradeable_learn_widget/trend_line/widgets/content_widget.dart';
import 'package:tradeable_learn_widget/trend_line/widgets/line_graph_widget.dart';
import 'package:tradeable_learn_widget/trend_line/widgets/line_mcq_question.dart';
import 'package:tradeable_learn_widget/trend_line/widgets/question_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_info_chips.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class TrendLineWidget extends StatefulWidget {
  final TrendLineModel model;
  final VoidCallback onNextClick;

  const TrendLineWidget(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<TrendLineWidget> createState() => _TrendLineState();
}

class _TrendLineState extends State<TrendLineWidget> {
  late TrendLineModel model;
  late double pos;
  late double value;
  late Offset startOffset;
  late Offset endOffset;
  List<Question> questions = [];
  int currentQuestionIndex = 0;

  @override
  void initState() {
    model = widget.model;
    startOffset = Offset(4, model.yMin);
    endOffset = Offset(model.candles.length - 4, model.yMax);
    getCandles();
    initOffsets();
    questions = TrendLineQuestionGenerator.generateQuestions(model);
    super.initState();
  }

  void initOffsets() {
    if (model.pointLabels.isNotEmpty) {
      for (int i = 0; i < model.pointLabels.length; i++) {
        model.pointLabelResponse.add(UserPointLabelResponse(
            model.pointLabels[i].tag,
            model.candles.length / 2 + i,
            model.yMax,
            Colors.blue));
      }
    }
    if (model.lineOffsets.isNotEmpty) {
      for (int i = 0; i < model.lineOffsets.length; i++) {
        List<UserLineResponse> userLineResponses = [];

        userLineResponses.add(UserLineResponse(
          i.toString(),
          [
            Offset(4,
                model.yMin + Random().nextDouble() * (model.yMax - model.yMin)),
            Offset(model.candles.length - 4,
                model.yMax - Random().nextDouble() * (model.yMax - model.yMin)),
          ],
          Colors.blue,
        ));

        model.lineResponse.add(userLineResponses);
      }
    }
  }

  void getCandles() async {
    model.uiCandles.clear();
    for (FinCandle candle in model.candles
        .map((e) => FinCandle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (model.atTime != 0) {
        if (candle.dateTime.millisecondsSinceEpoch <= model.atTime) {
          setState(() {
            model.uiCandles.add(candle);
          });
        } else {
          break;
        }
      } else {
        setState(() {
          model.uiCandles.add(candle);
        });
      }
    }
  }

  void goToNextQuestion() {
    setState(() {
      print(currentQuestionIndex);
      print(questions.length);
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        if (questions[currentQuestionIndex].type == "content") {
          widget.onNextClick();
        }
      } else {
        print("nexgt");
        widget.onNextClick();
      }
      model.userResponse = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    Question currentQuestion = questions[currentQuestionIndex];

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          QuestionWidget(question: questions[currentQuestionIndex].question),
          LineGraphWidget(
              model: model,
              constraints: constraints,
              question: questions[currentQuestionIndex].question),
          model.candles.isNotEmpty
              ? ChartInfoChips(
                  ticker: model.ticker,
                  timeFrame: model.timeframe,
                  date: DateFormat("dd MMM yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          model.candles.first.time)))
              : Container(),
          const SizedBox(height: 10),
          const Spacer(),
          if (currentQuestion.type == "line")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: ButtonWidget(
                  color: colors.primary,
                  btnContent: 'Submit',
                  onTap: () {
                    takeToCorrectOffsets();
                    Future.delayed(const Duration(seconds: 2)).then((value) {
                      goToNextQuestion();
                    });
                  }),
            ),
          if (currentQuestion.type == "mcq")
            LineMCQQuestionWidget(
              question: questions[currentQuestionIndex].question,
              model: model,
              options: questions[currentQuestionIndex].options!,
              correctResponse: questions[currentQuestionIndex].correctResponse!,
              onSubmit: () {
                if (currentQuestionIndex + 1 < questions.length - 1 &&
                    questions[currentQuestionIndex + 1].type == "mcq") {
                  loadCandlesTillEnd();
                }
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  goToNextQuestion();
                });
              },
            ),
          if (currentQuestion.type == "content")
            ContentWidget(content: questions[currentQuestionIndex].question)
        ],
      );
    });
  }

  void takeToCorrectOffsets() {
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
  }

  Future<void> loadCandlesTillEnd() async {
    if (model.atTime != 0) {
      for (FinCandle candle in model.candles
          .map((e) => FinCandle(
              candleId: e.candleNum,
              open: e.open,
              high: e.high,
              low: e.low,
              close: e.close,
              dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
              volume: e.vol.round()))
          .toList()) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (model.candles.length != model.uiCandles.length &&
            candle.dateTime.millisecondsSinceEpoch > model.atTime) {
          setState(() {
            model.uiCandles.add(candle);
          });
        }
      }
    }
  }
}
