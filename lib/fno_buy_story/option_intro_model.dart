class OptionIntroModel {
  late String content;
  late String question;
  late List<OptionCell> options;

  OptionIntroModel.fromJson(dynamic data) {
    content = data["content"];
    question = data["question"];
    options = (data["options"] as List)
        .map((e) => OptionCell(OptionModel.fromJson(e)))
        .toList();
  }
}

class OptionCell {
  OptionModel model;

  OptionCell(this.model);
}

class OptionModel {
  final String imgSrc;
  final String value;

  OptionModel(this.imgSrc, this.value);

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      json['imgSrc'] as String,
      json['value'] as String,
    );
  }
}
