const takeatradejson = {
  "id": "wait_watch_set_target_workflow",
  "name": "Wait and Watch or Set Target",
  "description":
      "Workflow to handle dynamic actions: wait and watch or set target and stop loss.",
  "steps": [
    {
      "stepId": "1",
      "ui": {
        "widget": "AnimatedText",
        "title": "Welcome",
        "prompt": "Welcome! Choose your next action."
      },
      "isSkippable": true,
      "nextStepId": "2"
    },
    {
      "stepId": "2",
      "ui": {
        "widget": "Container",
        "title": "Action Container",
        "containerStyle": {"height": 150, "width": 300, "color": "default"}
      },
      "isSkippable": true,
      "nextStepId": "3"
    },
    {
      "stepId": "3",
      "ui": {
        "widget": "Buttons",
        "title": "Select Action",
        "options": [
          {
            "label": "Wait and Watch",
            "action": "handleWaitAndWatch",
            "nextStepId": "4"
          },
          {
            "label": "Set Target and Stop Loss",
            "action": "showTextFields",
            "nextStepId": "5"
          }
        ]
      },
      "isSkippable": false
    },
    {
      "stepId": "4",
      "ui": {
        "widget": "Dialog",
        "title": "Confirm Action",
        "message": "Are you sure you want to wait and watch?",
        "options": [
          {"label": "Yes", "action": "changeAnimatedText", "nextStepId": "6"},
          {"label": "No", "action": "goBackToButtons", "nextStepId": "3"}
        ]
      },
      "isSkippable": false
    },
    {
      "stepId": "5",
      "ui": {
        "widget": "TextFields",
        "title": "Set Target and Stop Loss",
        "fields": [
          {"label": "Target Price", "type": "number"},
          {"label": "Stop Loss Price", "type": "number"}
        ]
      },
      "isSkippable": false,
      "nextStepId": "6"
    },
    {
      "stepId": "6",
      "ui": {
        "widget": "AnimatedText",
        "title": "Final Action",
        "prompt": "Your action has been completed successfully!"
      },
      "isSkippable": true,
      "nextStepId": null
    }
  ]
};
