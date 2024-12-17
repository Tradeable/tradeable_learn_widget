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
      "skippable": false,
      "nextStep": "2"
    },
    {
      "stepId": "2",
      "widget": "Container",
      "title": "Chart Display",
      "prompt": "Here is some chart data.",
      "skippable": true,
      "nextStep": "3"
    },
    {
      "stepId": "3",
      "widget": "CarouselSlider",
      "title": "Answer the following",
      "prompt": "Some prompt",
      "skippable": true,
      "nextStep": "4"
    },
    {
      "stepId": "3a",
      "widget": "AnimatedText",
      "title": "Number Guess",
      "prompt": "Guess a number lesser than 40:",
      "validationCriteria": "int.parse(input) < 40",
      "successMessage": "Correct! Click Next to continue.",
      "failureMessage": "Try again. Hint: It's lesser than 40.",
      "skippable": false,
      "nextStep": "3b"
    },
    {
      "stepId": "3b",
      "widget": "ImageWidget",
      "title": "Capital Guess",
      "prompt": "What is the capital of France?",
      "validationCriteria": "input.toLowerCase() == 'paris'",
      "successMessage": "Well done! Click Submit to proceed.",
      "failureMessage": "Incorrect. Please try again.",
      "skippable": false,
      "nextStep": "5"
    },
    {
      "stepId": "5",
      "widget": "AnimatedText",
      "title": "Completion Message",
      "prompt": "Congratulations! You have completed the quiz.",
      "skippable": true,
      "nextStep": null
    }
  ]
};
