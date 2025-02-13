const greeksTypeform = {
  "userStory": {
    "id": "",
    "name": "",
    "type": "user_story",
    "description": "",
    "steps": [
      {
        "stepId": "1",
        "isActionNeeded": true,
        "ui": [
          {
            "title": "CALL OPTION",
            "prompt": "Move the car; see what happens!",
            "widget": "AnimatedText",
            "imageUrl": "assets/axis_logo.png",
          },
          {"width": "", "height": "100", "widget": "SizedBox"},
          {
            "widget": "GreeksExplainerWidget",
            "greeksExplainerModel": {
              "currentStrikePrice": "19,900",
              "strikePrices": [
                {"title": "ITM", "value": "19,900"},
                {"title": "ITM", "value": "20,000"},
                {"title": "ATM", "value": "20,100"},
                {"title": "OTM", "value": "20,200"},
                {"title": "OTM", "value": "20,300"},
              ],
              "isCallOption": false,
              "isOptionToggleVisible": true,
              "showSliderLabels": true,
              "showAnimation": true,
              "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
              "premiumValues": ["60", "61", "62", "63", "64"],
            }
          },
          {
            "title": "Next",
            "action": "moveToNextStep",
            "widget": "NextButtonWidget"
          },
        ]
      },
      {
        "stepId": "2",
        "isActionNeeded": true,
        "ui": [
          {
            "title": "CALL OPTION",
            "prompt":
                "As the car moves from ITM to ATM, the call option loses value. A Delta between -1 and 0 means the option is less sensitive to price changes.\\\nTip! Watch for Delta changes as options approach ATM to manage risk effectively.",
            "widget": "AnimatedText",
            "imageUrl": "assets/axis_logo.png",
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "widget": "GreeksExplainerWidget",
            "greeksExplainerModel": {
              "currentStrikePrice": "20,100",
              "strikePrices": [
                {"title": "ITM", "value": "19,900"},
                {"title": "ITM", "value": "20,000"},
                {"title": "ATM", "value": "20,100"},
                {"title": "OTM", "value": "20,200"},
                {"title": "OTM", "value": "20,300"},
              ],
              "isCallOption": false,
              "isOptionToggleVisible": true,
              "showSliderLabels": true,
              "showAnimation": true,
              "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
              "premiumValues": ["60", "61", "62", "63", "64"],
            }
          },
          {
            "title": "Next",
            "action": "moveToNextStep",
            "widget": "NextButtonWidget"
          }
        ]
      },
      {
        "stepId": "3",
        "isActionNeeded": false,
        "ui": [
          {
            "title": "CALL OPTION",
            "prompt":
                "At ATM, the market views the call option as being at its most balanced point, with the delta around 0.5 indicating the option's value will change by roughly half the amount of the underlying asset's movement.",
            "widget": "AnimatedText",
            "imageUrl": "assets/axis_logo.png",
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "Next",
            "action": "moveToNextStep",
            "widget": "NextButtonWidget"
          }
        ]
      }
    ]
  }
};
