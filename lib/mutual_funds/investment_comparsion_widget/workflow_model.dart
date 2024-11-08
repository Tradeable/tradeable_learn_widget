class WorkflowStep {
  final int id;
  final String widget;
  final String prompt;
  final String action;
  final String nextStepCondition;
  final String errorMessage;
  final bool isFinalStep;

  WorkflowStep({
    required this.id,
    required this.widget,
    required this.prompt,
    required this.action,
    required this.nextStepCondition,
    required this.errorMessage,
    this.isFinalStep = false,
  });
}

final List<WorkflowStep> workflowSteps = [
  WorkflowStep(
    id: 1,
    widget: "ExpandableWidget",
    prompt: "Select a fund",
    action: "Select Fund",
    nextStepCondition: "selectedFund != null",
    errorMessage: "Please select a fund to continue.",
  ),
  WorkflowStep(
    id: 2,
    widget: "SavingsAmountWidget",
    prompt: "Set start and end dates and savings amount",
    action: "Set Dates and Amount",
    nextStepCondition:
        "(startDate != null && endDate != null && savingsAmount > 0 && endDate.difference(startDate).inDays >= 30)",
    errorMessage:
        "Please ensure the dates cover at least one month and all fields are filled.",
  ),
  WorkflowStep(
    id: 3,
    widget: "InvestmentReturnsTable",
    prompt: "View Your Investment Analysis",
    action: "Display Results",
    nextStepCondition: "avgReturns.any((element) => element != 0.0)",
    errorMessage: "",
    isFinalStep: true,
  ),
  WorkflowStep(
    id: 4,
    widget: "ConditionalPrompt",
    prompt: "You selected Fund C. Would you like to explore Fund A as well?",
    action: "Yes/No Prompt for Fund A",
    nextStepCondition: "selectedFund == 'Fund C'",
    errorMessage: "",
  ),
];
