final investmentComparisionModel = {
  "program":
      "import 'dart:core';\n\nbool isCurrentStepValid(int currentStepId, bool currentStepIsFinal, dynamic selectedFund, bool areDatesValid, double savingsAmount, bool avg) {\n  if (currentStepId == 1) {\n    return selectedFund != null;\n  } else if (currentStepId == 2) {\n    return areDatesValid && savingsAmount > 0;\n  } else if (currentStepId == 3) {\n    return avg;\n  } else if (currentStepId == 4) {\n    return selectedFund == 'Fund C';\n  } else {\n    return false;\n  }\n}",
  "workflowSteps": [
    {
      "id": 1,
      "widget": "ExpandableWidget",
      "prompt": "Select a fund",
      "action": "Select Fund",
      "nextStepCondition": "selectedFund != null",
      "errorMessage": "Please select a fund to continue."
    },
    {
      "id": 2,
      "widget": "SavingsAmountWidget",
      "prompt": "Set start and end dates and savings amount",
      "action": "Set Dates and Amount",
      "nextStepCondition":
          "(startDate != null && endDate != null && savingsAmount > 0 && endDate.difference(startDate).inDays >= 30)",
      "errorMessage":
          "Please ensure the dates cover at least one month and all fields are filled."
    },
    {
      "id": 3,
      "widget": "InvestmentReturnsTable",
      "prompt": "View Your Investment Analysis",
      "action": "Display Results",
      "nextStepCondition": "avgReturns.any((element) => element != 0.0)",
      "errorMessage": "",
      "isFinalStep": true
    },
    {
      "id": 4,
      "widget": "ConditionalPrompt",
      "prompt":
          "You selected Fund C. Would you like to explore Fund A as well?",
      "action": "Yes/No Prompt for Fund A",
      "nextStepCondition": "selectedFund == 'Fund C'",
      "errorMessage": ""
    }
  ]
};
