class FormulaPlaceHolderModel {
  late String title;
  late String situation;
  late List<String> questions;
  late List<DraggableFormulaOption> options;
  late List<String> formulas;
  late Map<String, String> formulaValues = {};
  late Map<String, String> correctOptionTargets = {};
  late bool hideQuestions;

  FormulaPlaceHolderModel.fromJson(dynamic data) {
    title = data['title'] ?? '';
    situation = data['situation'] ?? '';
    questions = List<String>.from(data['questions'] ?? []);
    options = List<String>.from(data['options'] ?? [])
        .map((option) => DraggableFormulaOption(option))
        .toList();
    formulas = List<String>.from(data['formulas'] ?? []);
    correctOptionTargets =
        Map<String, String>.from(data['correctOptionTargets'] ?? {});
    hideQuestions = data["hideQuestions"] ?? false;
    for (String question in questions) {
      formulaValues[question] = '';
    }
  }
}

class DraggableFormulaOption {
  final String optionText;

  DraggableFormulaOption(this.optionText);
}
