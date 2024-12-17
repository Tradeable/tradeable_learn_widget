class ChartUserStoryModel {
  late String id;
  late String name;
  late String description;
  late List<WorkflowStep> steps;

  ChartUserStoryModel.fromJson(dynamic data) {
    id = data["id"];
    name = data["name"];
    description = data["description"];
    steps = (data["steps"] as List)
        .map((x) => WorkflowStep(
              stepId: x["stepId"],
              widget: x["widget"],
              title: x["title"],
              prompt: x["prompt"],
              validationCriteria: x["validationCriteria"],
              successMessage: x["successMessage"],
              failureMessage: x["failureMessage"],
              nextStep: x["nextStep"],
              skippable: x["skippable"] ?? false,
            ))
        .toList();
  }
}

class WorkflowStep {
  late String stepId;
  late String widget;
  late String title;
  late String prompt;
  dynamic validationCriteria;
  String? successMessage;
  String? failureMessage;
  String? nextStep;
  bool skippable;

  WorkflowStep({
    required this.stepId,
    required this.widget,
    required this.title,
    required this.prompt,
    this.validationCriteria,
    this.successMessage,
    this.failureMessage,
    this.nextStep,
    this.skippable = false,
  });
}
