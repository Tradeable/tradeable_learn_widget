class InfoReelModel {
  String markdownString = "";
  late bool isLast;

  InfoReelModel.fromJson(dynamic data) {
    markdownString = data["md"];
    if (data.containsKey("isLast")) {
      isLast = data["isLast"];
    } else {
      isLast = false;
    }
  }
}
