const userStory2 = {
  "id": "dynamic_container_workflow",
  "name": "Dynamic Container Quiz",
  "description":
      "A quiz workflow with a dynamic container that changes based on user responses.",
  "steps": [
    {
      "stepId": "1",
      "ui": {
        "widget": "AnimatedText",
        "title": "Welcome",
        "prompt": "Welcome to the quiz! Let's start by selecting a color."
      },
      "actions": ["moveNext"]
    },
    {
      "stepId": "2",
      "ui": {
        "widget": "Container",
        "title": "Dynamic Container",
        "containerStyle": {"height": 100, "width": 100, "color": "default"}
      },
      "actions": ["moveNext"]
    },
    {
      "stepId": "3",
      "ui": {
        "widget": "Question",
        "title": "Select a Color",
        "prompt": "Choose a color for the container.",
        "inputType": "mcq",
        "options": ["Red", "Blue", "Green"],
        "userResponse": null
      },
      "actions": ["updateJson(response.color)", "moveNext"]
    },
    {
      "stepId": "4",
      "ui": {
        "widget": "Container",
        "title": "Dynamic Container",
        "containerStyle": {
          "height": 100,
          "width": 100,
          "color": "response.color"
        }
      },
      "actions": ["moveNext"]
    },
    {
      "stepId": "5",
      "ui": {
        "widget": "Question",
        "title": "Adjust Container Width",
        "prompt": "Use the slider to adjust the container's width.",
        "inputType": "slider",
        "userResponse": null
      },
      "actions": ["updateJson(response.width)", "moveNext"]
    },
    {
      "stepId": "6",
      "ui": {
        "widget": "Container",
        "title": "Dynamic Container",
        "containerStyle": {
          "height": 100,
          "width": "response.width",
          "color": "response.color"
        }
      },
      "actions": ["moveNext"]
    },
    {
      "stepId": "7",
      "ui": {
        "widget": "Question",
        "title": "Enter Text",
        "prompt": "Enter some text to display in the container.",
        "inputType": "text",
        "userResponse": null
      },
      "actions": ["updateJson(response.text)", "moveNext"]
    },
    {
      "stepId": "8",
      "ui": {
        "widget": "Container",
        "title": "Final Container",
        "containerStyle": {
          "height": 100,
          "width": "response.width",
          "color": "response.color",
          "text": "response.text"
        }
      },
      "actions": ["end"]
    }
  ]
};

/*
step1: load data in animated text and load candle data in chart with animation and display the first question
step2: if first question ans is 'a' then load data in animated text and load candle data and ask second question
step3: if ans is not 'a' load animated text and load candle data
step4: if user selects 'a' again load animated text
 */

const userStory3 = {
  "id": "generalized_dynamic_workflow",
  "name": "Generalized Dynamic Workflow",
  "description":
      "A workflow with 3 constant widgets: AnimatedText, Container, and a dynamic input widget.",
  "steps": [
    {
      "stepId": "1",
      "ui": {
        "animatedText": {
          "title": "Welcome",
          "prompt": "Welcome to the quiz! Select a color to begin."
        },
        "container": {
          "title": "Dynamic Container",
          "style": {"height": 100, "width": 100, "color": "default", "text": ""}
        },
        "dynamicWidget": {
          "widget": "MCQ",
          "title": "Select a Color",
          "prompt": "Choose a color for the container.",
          "options": ["Red", "Blue", "Green"],
          "userResponse": null
        }
      },
      "actions": ["updateContainerStyle(response.color)", "moveNext"]
    },
    {
      "stepId": "2",
      "ui": {
        "animatedText": {
          "title": "Adjust Width",
          "prompt": "Now, adjust the container's width using the slider."
        },
        "container": {
          "title": "Dynamic Container",
          "style": {
            "height": 100,
            "width": 100,
            "color": "response.color",
            "text": ""
          }
        },
        "dynamicWidget": {
          "widget": "Slider",
          "title": "Adjust Width",
          "prompt": "Slide to adjust the width of the container.",
          "range": [100, 300],
          "userResponse": null
        }
      },
      "actions": ["updateContainerStyle(response.width)", "moveNext"]
    },
    {
      "stepId": "3",
      "ui": {
        "animatedText": {
          "title": "Enter Text",
          "prompt": "Finally, enter text to display inside the container."
        },
        "container": {
          "title": "Dynamic Container",
          "style": {
            "height": 100,
            "width": "response.width",
            "color": "response.color",
            "text": ""
          }
        },
        "dynamicWidget": {
          "widget": "TextInput",
          "title": "Enter Text",
          "prompt": "Type some text to display in the container.",
          "userResponse": null
        }
      },
      "actions": ["updateContainerStyle(response.text)", "moveNext"]
    },
    {
      "stepId": "4",
      "ui": {
        "animatedText": {
          "title": "Completion",
          "prompt": "You have completed the workflow. Great job!"
        },
        "container": {
          "title": "Final Container",
          "style": {
            "height": 100,
            "width": "response.width",
            "color": "response.color",
            "text": "response.text"
          }
        },
        "dynamicWidget": {
          "widget": "None",
          "title": "",
          "prompt": "",
          "userResponse": null
        }
      },
      "actions": ["end"]
    }
  ]
};
