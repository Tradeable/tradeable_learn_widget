import 'package:tradeable_learn_widget/utils/explanation_model.dart';

class ATMWidgetModel {
  late String question;
  late String correctResponse;
  late List<DataCell> entries;
  late List<String> options;
  ExplanationV1? explanationV1;

  ATMWidgetModel.fromJson(dynamic data) {
    question = data["question"];
    correctResponse = data["correctResponse"];
    entries = (data["entries"] as List)
        .map((e) => DataCell(ATMDataModel.fromJson(e)))
        .toList();
    options = data["options"].cast<String>() as List<String>;
    explanationV1 = data["explaination"] != null
        ? ExplanationV1(
            forCorrect: (data["explaination"]["forCorrect"] as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e as Map<String, dynamic>))
                .toList(),
            forIncorrect: (data["explaination"]["forIncorrect"]
                    as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e as Map<String, dynamic>))
                .toList(),
          )
        : ExplanationV1(
            forCorrect: [
              ExplainerV1(
                title: "Correct",
                data: "You got it correct",
                imageUrl: "assets/btmsheet_correct.png",
              )
            ],
            forIncorrect: [
              ExplainerV1(
                title: "Incorrect",
                data: "You got it incorrect",
                imageUrl: "assets/btmsheet_incorrect.png",
              )
            ],
          );
  }
}

class DataCell {
  ATMDataModel model;

  DataCell(this.model);
}

class ATMDataModel {
  final String title;
  final String value;
  final bool isQuestion;

  ATMDataModel(this.title, this.value, this.isQuestion);

  factory ATMDataModel.fromJson(Map<String, dynamic> json) {
    return ATMDataModel(
      json['title'] as String,
      json['value'] as String,
      json['isQuestion'] as bool,
    );
  }
}
