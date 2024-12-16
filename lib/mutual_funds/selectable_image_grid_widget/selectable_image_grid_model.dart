import 'package:tradeable_learn_widget/utils/explanation_model.dart';

class SelectableImageGridModel {
  late String imageTitle;
  late String title;
  late String question;
  late List<String> imageUrls;
  late List<String> correctResponses;
  late bool isCorrect;
  ExplanationV1? explanationV1;

  SelectableImageGridModel.fromJson(dynamic data) {
    title = data["imageTitle"] ?? "";
    title = data["title"] ?? "";
    question = data['question'] ?? '';
    imageUrls = List<String>.from(data['imageUrls'] ?? []);
    correctResponses = List<String>.from(data['correctResponses'] ?? []);
    explanationV1 = data["explanation"] != null
        ? ExplanationV1(
            forCorrect: (data["explanation"]["forCorrect"] as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e))
                .toList(),
            forIncorrect:
                (data["explanation"]["forIncorrect"] as List<dynamic>?)
                    ?.map((e) => ExplainerV1.fromJson(e))
                    .toList(),
          )
        : ExplanationV1(forCorrect: [
            ExplainerV1(
              title: "Correct",
              data: "You got it correct",
              imageUrl: "assets/btmsheet_correct.png",
            )
          ], forIncorrect: [
            ExplainerV1(
              title: "Incorrect",
              data: "You got it incorrect",
              imageUrl: "assets/btmsheet_incorrect.png",
            )
          ]);
  }
}

class ImageItem {
  final String imageUrl;
  bool isSelected;

  ImageItem({required this.imageUrl, this.isSelected = false});
}
