class ExplanationV1 {
  final List<ExplainerV1>? forCorrect;
  final List<ExplainerV1>? forIncorrect;

  ExplanationV1({required this.forCorrect, required this.forIncorrect});

  List<ExplainerV1> getExplanation(bool isAnsCorrect) {
    if (isAnsCorrect) {
      return forCorrect ??
          [
            ExplainerV1(
              title: "Correct",
              data: "You got it correct",
              imageUrl: "/assets/btmsheet_correct.png",
            )
          ];
    } else {
      return forIncorrect ??
          [
            ExplainerV1(
              title: "Incorrect",
              data: "You got it incorrect",
              imageUrl: "/assets/btmsheet_incorrect.png",
            )
          ];
    }
  }

  ExplanationV1 getRRExplanation(bool isAnsCorrect, String resultText) {
    if (isAnsCorrect) {
      return ExplanationV1(
        forCorrect: [
          ExplainerV1(
            title: "Correct",
            data: resultText.isEmpty ? "You got it correct" : resultText,
            imageUrl: "assets/btmsheet_correct.png",
          ),
        ],
        forIncorrect: [],
      );
    } else {
      return ExplanationV1(
        forCorrect: [],
        forIncorrect: [
          ExplainerV1(
            title: "Incorrect",
            data: resultText.isEmpty ? "You got it incorrect" : resultText,
            imageUrl: "assets/btmsheet_incorrect.png",
          ),
        ],
      );
    }
  }
}

class ExplainerV1 {
  final String? title;
  final String? data;
  final String? imageUrl;

  ExplainerV1({required this.title, required this.data, this.imageUrl});

  factory ExplainerV1.fromJson(Map<String, dynamic> json) {
    return ExplainerV1(
      title: json['title'],
      data: json['data'],
      imageUrl: json['imageUrl'],
    );
  }
}
