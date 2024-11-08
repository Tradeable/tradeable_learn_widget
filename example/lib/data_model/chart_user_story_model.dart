const chartUserStoryModel = {
  "id": "quiz_workflow",
  "name": "Quiz App",
  "description": "A step-by-step quiz workflow",
  "steps": [
    {
      "stepId": "1",
      "widget": "AnimatedText",
      "title": "Welcome Message",
      "prompt": "Welcome to the quiz! Get ready for the first question.",
      "nextStep": "2"
    },
    {
      "stepId": "2",
      "widget": "Container",
      "title": "Chart Display",
      "prompt": "Here is some chart data.",
      "nextStep": "3"
    },
    {
      "stepId": "3",
      "widget": "TextInput",
      "title": "Number Guess",
      "prompt": "Guess the correct number:",
      "validationCriteria": "42", // Directly set the correct answer here
      "successMessage": "Correct! Click Next to continue.",
      "failureMessage": "Try again.",
      "nextStep": "4"
    },
    {
      "stepId": "4",
      "widget": "TextInput",
      "title": "Capital Guess",
      "prompt": "What is the capital of France?",
      "validationCriteria": "Paris", // Directly set the correct answer here
      "successMessage": "Well done! Click Next to proceed.",
      "failureMessage": "Incorrect. Please try again.",
      "nextStep": "5"
    },
    {
      "stepId": "5",
      "widget": "AnimatedText",
      "title": "Completion Message",
      "prompt": "Congratulations! You have completed the quiz.",
      "nextStep": null
    }
  ]
};
