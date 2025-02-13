import 'package:tradeable_learn_widget/reading_option_chain/node.dart';

class OptionChainModel {
  String screenTitle = "Reading a Option Chain";
  String screenDesc =
      "An option chain displays all available option contracts for an asset, including calls and puts, It helps traders analyze the market and make timely decisions.";
  int currentNodeIndex = 0;
  List<Node> nodes = [
    Node("Ol",
        "Open Interest (OI) reflects trader interest in a specific Option strike price. It indicates the number of contracts traded but not exercised or squared off. Higher OI means more trader interest and liquidity for desired Option trading."),
    Node("Chnge Ol",
        "Change in OI indicates changes in Open Interest during the expiration period, reflecting closed, exercised, or squared off contracts. Monitor significant changes in OI closely."),
    Node("Vol",
        "Volume is the total number of options contracts bought and sold in a particular time period"),
  ];
  List<String> strikes = [
    "18550",
    "18500",
    "18600",
    "18650",
    "18700",
    "18750",
    "18800",
    "18850",
    ""
  ];
  bool isFinished = false;

  void goToNextNode() {
    if (currentNodeIndex < nodes.length - 1) {
      currentNodeIndex++;
    }
    if (currentNodeIndex + 1 == nodes.length) {
      isFinished = true;
    }
  }

  void goToPreviousNode() {
    if (currentNodeIndex > 0) {
      currentNodeIndex--;
    }
  }

  void reset() {
    currentNodeIndex = 0;
    isFinished = false;
  }
}
