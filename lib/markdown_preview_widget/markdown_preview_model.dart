class MarkdownPreviewModel {
  late String content;

  MarkdownPreviewModel.fromJson(dynamic data) {
    content = data["content"];
  }
}
