
import 'package:tradeable_learn_widget/en1_matchthepair/match_the_pair_item.dart';

class EN1Model {
  late List<LeftColumItem> leftColumn;
  late List<RightColumnItem> rightColumn;
  late int startTime;
  bool isCorrect = false;
  LeftColumItem? selectedItemLeft;
  RightColumnItem? selectedItemRight;

  late bool notifyAnswered;

  EN1State state = EN1State.isMatching;

  EN1Model.fromJson(dynamic data) {
    leftColumn =
        (data["leftColumn"] as List).map((e) => LeftColumItem(e)).toList();
    rightColumn = (data["rightColumn"] as List)
        .map((e) => RightColumnItem(MatchThePairItem.fromJson(e)))
        .toList();
  }
}

enum EN1State { isMatching, submitResponse }

enum ColumnItemState { unselected, selected, correct, incorrect }

class LeftColumItem {
  String text;
  ColumnItemState state = ColumnItemState.unselected;

  LeftColumItem(this.text);
}

class RightColumnItem {
  MatchThePairItem item;
  ColumnItemState state = ColumnItemState.unselected;

  RightColumnItem(this.item);
}
