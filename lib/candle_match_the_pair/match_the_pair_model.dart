enum CandlePartMatchLinkState { loadUI, submitResponse }

class CandleMatchThePairModel {
  final dynamic data;
  late List<String> pairFor;
  late bool isBullish;
  late int startTime;
  CandlePartMatchLinkState state = CandlePartMatchLinkState.loadUI;

  bool isCorrect = false;

  CandleMatchThePairModel(this.data) {
    pairFor = (data["pairFor"] as List).map((e) => e.toString()).toList();
    isBullish = data["isBullish"];
  }
}