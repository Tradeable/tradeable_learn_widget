class WebpageModel {
  String url = "";
  late bool isLast;

  WebpageModel.fromJson(dynamic data) {
    url = data["url"];
    if (data.containsKey("isLast")) {
      isLast = data["isLast"];
    } else {
      isLast = false;
    }
  }
}
