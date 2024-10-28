class SelectableImageGridModel {
  late String imageTitle;
  late String title;
  late String question;
  late List<String> imageUrls;
  late List<String> correctResponses;
  late bool isCorrect;

  SelectableImageGridModel.fromJson(dynamic data) {
    title = data["imageTitle"] ?? "";
    title = data["title"] ?? "";
    question = data['question'] ?? '';
    imageUrls = List<String>.from(data['imageUrls'] ?? []);
    correctResponses = List<String>.from(data['correctResponses'] ?? []);
  }
}

class ImageItem {
  final String imageUrl;
  bool isSelected;

  ImageItem({required this.imageUrl, this.isSelected = false});
}
