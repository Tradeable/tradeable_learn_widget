
import 'dart:math';

enum CandleBodySelectState { loadUI, submitResponse }

class CandlePartSelectModel {
  late String question;
  late String correctAnswer;
  late String correctResponse;
  String? userResponse;
  final random = Random();
  double wickHeight = 0;
  double tailHeight = 0;
  double bodyHeight = 0;
  bool isBullish = true;
  CandleBodySelectState state = CandleBodySelectState.loadUI;
  late int startTime;
  bool isCorrect = false;

  CandlePartSelectModel.fromJson(dynamic data) {
    question = data['question'];
    correctResponse = data["correctResponse"];
    correctAnswer = correctResponse;
    wickHeight = next(60, 100).toDouble();
    tailHeight = next(60, 100).toDouble();
    bodyHeight = next(60, 200).toDouble();
    isBullish = random.nextBool();
  }

  int next(int min, int max) => min + random.nextInt(max - min);
}