enum CandlePartMatchLinkState { loadUI, submitResponse }

class CandleMatchThePairModel {
  late List<String> pairFor;
  late bool isBullish;
  late int startTime;
  CandlePartMatchLinkState state = CandlePartMatchLinkState.loadUI;

  bool isCorrect = false;

  CandleMatchThePairModel.fromJson(dynamic data) {
    pairFor = (data["pairFor"] as List).map((e) => e.toString()).toList();
    isBullish = data["isBullish"];
  }
}