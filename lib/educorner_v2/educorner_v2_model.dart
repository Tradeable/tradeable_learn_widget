class EducornerV2Model {
  late List<EduCornerV2Item> items;

  EducornerV2Model.fromJson(dynamic data) {
    items = data["items"] != null
        ? ((data["items"]) as List)
            .map((x) => EduCornerV2Item.fromJson(x))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() => {
        "items": items.map((item) => item.toJson()).toList(),
      };
}

class EduCornerV2Item {
  late String imageUrl;
  late String content;

  EduCornerV2Item({required this.imageUrl, required this.content});

  EduCornerV2Item.fromJson(Map<String, dynamic> json) {
    imageUrl = json["imageUrl"] ?? "";
    content = json["content"] ?? "";
  }

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "content": content,
      };
}
