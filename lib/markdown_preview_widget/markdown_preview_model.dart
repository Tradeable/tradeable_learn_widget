class MarkdownPreviewModel {
  final dynamic data;
  late String content;

  MarkdownPreviewModel(this.data) {
    content = data["content"];
  }
}
