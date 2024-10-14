class SelectableImageGridModel {
  final dynamic data;
  late String question;
  late List<String> imageUrls;
  late List<String> correctResponses;
  late bool isCorrect;

  SelectableImageGridModel(this.data) {
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
