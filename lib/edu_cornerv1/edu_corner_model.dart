enum EduCornerContentType { imageAndText, onlyImage, onlyText }

class EduCornerModel {
  late String title;
  late List<EduCornerContent> cards;

  EduCornerModel.fromJson(dynamic data) {
    title = data["title"];
    cards = ((data["cards"]) as List)
        .map((x) => EduCornerContent.fromJson(x))
        .toList();
  }
}

class EduCornerContent {
  final EduCornerContentType type;
  final String? imgUrl;
  final String? videoId;
  final EduCornerTextContent? textContent;

  EduCornerContent(
      {required this.type, this.imgUrl, this.videoId, this.textContent});

  factory EduCornerContent.fromJson(Map<String, dynamic> json) {
    return EduCornerContent(
      type: _parseContentType(json['type']),
      imgUrl: json['imgUrl'],
      videoId: json['videoId'],
      textContent: EduCornerTextContent.fromJson(json['textContent']),
    );
  }

  static EduCornerContentType _parseContentType(String type) {
    switch (type) {
      case 'imageAndText':
        return EduCornerContentType.imageAndText;
      case 'onlyImage':
        return EduCornerContentType.onlyImage;
      case 'onlyText':
        return EduCornerContentType.onlyText;
      default:
        throw ArgumentError('Invalid content type: $type');
    }
  }
}

class EduCornerTextContent {
  final String? title;
  final String? content;

  EduCornerTextContent({this.title, this.content});

  factory EduCornerTextContent.fromJson(Map<String, dynamic> json) {
    return EduCornerTextContent(
      title: json['title'],
      content: json['content'],
    );
  }
}
