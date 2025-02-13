class BananaModel {
  late String content1;
  late String content2;
  late String content3;
  late Infographic infographic;
  late bool isSliderToBeShown;
  late List<String> helperText;

  BananaModel.fromJson(dynamic data) {
    content1 = data["content1"];
    content2 = data["content2"];
    content3 = data["content3"];
    isSliderToBeShown = data["isSliderToBeShown"];
    infographic = Infographic.fromJson(data["infographic"]);
    helperText = data["helper_text"].cast<String>() as List<String>;
  }
}

class Infographic {
  String? infographicId;
  String? title;
  String? content;
  List<String>? imageUrls;
  String? publishOn;
  List<String>? collectionTag;
  String? author;

  Infographic({
    this.infographicId,
    this.title,
    this.content,
    this.imageUrls,
    this.publishOn,
    this.collectionTag,
    this.author,
  });

  factory Infographic.fromJson(Map<String, dynamic> json) {
    return Infographic(
      infographicId: json['infographicId'],
      title: json['title'],
      content: json['content'],
      imageUrls: (json['imageUrls'] as List?)?.map((e) => e as String).toList(),
      publishOn: json['publishOn'],
      collectionTag:
          (json['collectionTag'] as List?)?.map((e) => e as String).toList(),
      author: json['author'],
    );
  }
}
