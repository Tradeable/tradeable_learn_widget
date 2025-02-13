class IndexPageModel {
  late String title;
  late String image;
  late String description;
  late String intro;
  late List<String> content;

  IndexPageModel.fromJson(dynamic data) {
    title = data["title"];
    description = data["description"];
    intro = data["intro"];
    image = data["image"];
    content = (data["content"] as List).map((e) => e.toString()).toList();
  }
}
