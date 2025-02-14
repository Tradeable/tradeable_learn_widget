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
            "prompt":
                "As the car moves from ITM to ATM, the market is interpreting this as the underlying asset (the car) moving closer to the option's strike price. This results in the call option's premium value decreasing, as the option is becoming less valuable. The delta range from -1 to 0 reflects the reduced sensitivity of the call option's value to changes in the underlying asset.",
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
              "isCallOption": true,
              "isOptionToggleVisible": true,
              "showSliderLabels": true,
              "showAnimation": true,
              "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
              "premiumValues": ["60", "61", "62", "63", "64"],
              "stopValue": 2,
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
                "At ATM, the market views the call option as being at its most balanced point, with the delta around 0.5 indicating the option's value will change by roughly half the amount of the underlying asset's movement.",
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
              "isCallOption": true,
              "isOptionToggleVisible": true,
              "showSliderLabels": true,
              "showAnimation": true,
              "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
              "premiumValues": ["60", "61", "62", "63", "64"],
              "stopValue": 4,
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
                "As the car moves from ATM to OTM, the market sees the call option becoming less valuable, as the underlying asset is moving further away from the strike price. The delta approaching 0 shows the call option's value is less sensitive to changes in the underlying asset.",
            "widget": "AnimatedText",
            "imageUrl": "assets/axis_logo.png",
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "widget": "GreeksExplainerWidget",
            "greeksExplainerModel": {
              "currentStrikePrice": "20,300",
              "strikePrices": [
                {"title": "ITM", "value": "19,900"},
                {"title": "ITM", "value": "20,000"},
                {"title": "ATM", "value": "20,100"},
                {"title": "OTM", "value": "20,200"},
                {"title": "OTM", "value": "20,300"},
              ],
              "isCallOption": true,
              "isOptionToggleVisible": true,
              "showSliderLabels": true,
              "showAnimation": false,
              "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
              "premiumValues": ["60", "61", "62", "63", "64"],
              "stopValue": 4,
            }
          },
          {
            "title": "Next",
            "action": "moveNext",
            "widget": "NextButtonWidget"
          }
        ]
      }
    ]
  }
};

// const greeksTypeform = {
//   "userStory": {
//     "id": "",
//     "name": "",
//     "type": "user_story",
//     "description": "",
//     "steps": [
//       {
//         "stepId": "1",
//         "isActionNeeded": true,
//         "ui": [
//           {
//             "title": "PUT OPTION",
//             "prompt":
//                 "When the toggle is switched to 'PUT', the market interpretation is the opposite of the call option. As the car moves from OTM to ATM, the put option's delta ranges from 0 to -0.5, indicating the put option's value is becoming more sensitive to changes in the underlying asset.",
//             "widget": "AnimatedText",
//             "imageUrl": "assets/axis_logo.png",
//           },
//           {"width": "", "height": "100", "widget": "SizedBox"},
//           {
//             "widget": "GreeksExplainerWidget",
//             "greeksExplainerModel": {
//               "currentStrikePrice": "20,300",
//               "strikePrices": [
//                 {"title": "OTM", "value": "20,300"},
//                 {"title": "OTM", "value": "20,200"},
//                 {"title": "ATM", "value": "20,100"},
//                 {"title": "ITM", "value": "20,000"},
//                 {"title": "ITM", "value": "19,900"}
//               ],
//               "isCallOption": false,
//               "isOptionToggleVisible": true,
//               "showSliderLabels": true,
//               "showAnimation": true,
//               "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
//               "premiumValues": ["60", "61", "62", "63", "64"],
//               "stopValue": 2,
//             }
//           },
//           {
//             "title": "Next",
//             "action": "moveToNextStep",
//             "widget": "NextButtonWidget"
//           },
//         ]
//       },
//       {
//         "stepId": "2",
//         "isActionNeeded": true,
//         "ui": [
//           {
//             "title": "PUT OPTION",
//             "prompt":
//                 "At ATM, the market views the put option as being at a point of balance, with the delta around -0.5 showing the put option's value will change by roughly half the amount of the underlying asset's movement.",
//             "widget": "AnimatedText",
//             "imageUrl": "assets/axis_logo.png",
//           },
//           {"width": "", "height": "40", "widget": "SizedBox"},
//           {
//             "widget": "GreeksExplainerWidget",
//             "greeksExplainerModel": {
//               "currentStrikePrice": "20,100",
//               "strikePrices": [
//                 {"title": "OTM", "value": "20,300"},
//                 {"title": "OTM", "value": "20,200"},
//                 {"title": "ATM", "value": "20,100"},
//                 {"title": "ITM", "value": "20,000"},
//                 {"title": "ITM", "value": "19,900"}
//               ],
//               "isCallOption": false,
//               "isOptionToggleVisible": true,
//               "showSliderLabels": true,
//               "showAnimation": true,
//               "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
//               "premiumValues": ["60", "61", "62", "63", "64"],
//               "stopValue": 4,
//             }
//           },
//           {
//             "title": "Next",
//             "action": "moveToNextStep",
//             "widget": "NextButtonWidget"
//           }
//         ]
//       },
//       {
//         "stepId": "3",
//         "isActionNeeded": false,
//         "ui": [
//           {
//             "title": "PUT OPTION",
//             "prompt":
//                 "As the car continues to move from ATM to ITM, the market sees the put option becoming more valuable, as the underlying asset is moving further away from the strike price. The put option's delta approaching -1 reflects the high sensitivity of the option's value to changes in the underlying asset.",
//             "widget": "AnimatedText",
//             "imageUrl": "assets/axis_logo.png",
//           },
//           {"width": "", "height": "40", "widget": "SizedBox"},
//           {
//             "widget": "GreeksExplainerWidget",
//             "greeksExplainerModel": {
//               "currentStrikePrice": "19,900",
//               "strikePrices": [
//                 {"title": "OTM", "value": "20,300"},
//                 {"title": "OTM", "value": "20,200"},
//                 {"title": "ATM", "value": "20,100"},
//                 {"title": "ITM", "value": "20,000"},
//                 {"title": "ITM", "value": "19,900"}
//               ],
//               "isCallOption": false,
//               "isOptionToggleVisible": true,
//               "showSliderLabels": true,
//               "showAnimation": false,
//               "sliderLabels": ["-1", "-0.75", "-0.5", "-0.25", "0"],
//               "premiumValues": ["60", "61", "62", "63", "64"],
//               "stopValue": 4,
//             }
//           },
//           {"title": "Next", "action": "moveToNextStep", "widget": "moveNext"}
//         ]
//       }
//     ]
//   }
// };
