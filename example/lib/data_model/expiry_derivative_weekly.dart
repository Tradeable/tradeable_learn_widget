const expiryDerivativeWeekly = {
  "userStory": {
    "id": "",
    "name": "expiry_user_story",
    "description": "",
    "steps": [
      {
        "stepId": "1",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Similarly in derivatives there are different contract expiries"
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": false,
                  "isDisabled": false
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": false,
                  "isDisabled": false
                }
              ]
            },
          },
          {
            "widget": "SizedBox",
            "height": "20",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "widget": "ContractsInfo",
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 01-02-2025",
                  "isExpanded": false,
                  "isDisabled": false
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "01-01-2025 to 01-03-2025",
                  "isExpanded": false,
                  "isDisabled": false
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": false
      },
      {
        "stepId": "2",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt": "Let’s take a look at the weekly expiries."
          },
          {
            "widget": "SizedBox",
            "height": "60",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": false
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": false
      },
      {
        "stepId": "3",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Let’s assume you pick this week’s expiry. That would mean that you have until the end of the week to decide on whether you let the option expire."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": true
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": false
      },
      {
        "stepId": "4",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt": "As the week progresses, each day passes."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": true
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": true
      },
      {
        "stepId": "5",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Once the last day of the week has come to a close, the option will expire (if it has not been bought)."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": true
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": false
      },
      {
        "stepId": "6",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Now let’s assume you pick next week’s expiry, instead. That would mean that you have another week to decide on whether you let the option expire."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": false
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": false
      },
      {
        "stepId": "7",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "As with the last example, as the first week progresses, each day passes."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": true
      },
      {
        "stepId": "8",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "We come to the end of week one. However, since you have picked next week’s expiry, the option has not expired yet.We move on to the next week."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": false
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": false
      },
      {
        "stepId": "9",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt": "As the week progresses, each day passes."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                }
              ]
            },
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "isActionNeeded": true
      },
      {
        "stepId": "10",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Once the last day of the second week has come to a close, the option will expire (if it has not been bought)."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Weekly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Week",
                  "timeline": "01-01-2025 to 07-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Week",
                  "timeline": "08-01-2025 to 14-01-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                }
              ]
            },
          },
          {"widget": "NextButtonWidget", "title": "Next", "action": "moveNext"}
        ],
        "isActionNeeded": false
      },
    ]
  }
};
