class ATMWidgetModel {
  late String question;
  late String correctResponse;
  late List<DataCell> entries;
  late List<String> options;

  ATMWidgetModel.fromJson(dynamic data) {
    question = data["question"];
    correctResponse = data["correctResponse"];
    entries = (data["entries"] as List)
        .map((e) => DataCell(ATMDataModel.fromJson(e)))
        .toList();
    options = data["options"].cast<String>() as List<String>;
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
