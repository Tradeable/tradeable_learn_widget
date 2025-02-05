const expiryDerivativeMonthly = {
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
            "prompt": "Now, let’s take a look at the monthly expiries."
          },
          {
            "widget": "SizedBox",
            "height": "60",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "stepId": "2",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Let’s assume you pick this month’s expiry. That would mean that you have until the end of the month to decide on whether you let the option expire."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "stepId": "3",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt": "As the month progresses, each day - then weeks - passes."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "stepId": "4",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Once the last day of the month has come to a close, the option will expire (if it has not been bought)."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true,
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "stepId": "5",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Now let’s assume you pick next month’s expiry, instead. That would mean that you have another month to decide on whether you let the option expire."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "stepId": "6",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "As with the last example, this month passes with each day and week."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "isActionNeeded": true
      },
      {
        "stepId": "7",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "We have come to the end of this month. However, since you have picked next month’s expiry, the option has not expired yet.We move on to the next month."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "stepId": "8",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "As the second month progresses, each day, and week, passes."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
        "stepId": "9",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "Once the last day of the second month has come to a close, the option will expire (if it has not been bought)."
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "ContractsInfo",
            "contractsInfo": {
              "title": "Monthly Contracts",
              "contractDetails": [
                {
                  "ticker": "NIFTY",
                  "timeFrame": "This Month",
                  "timeline": "01-01-2025 to 07-02-2025",
                  "isExpanded": true,
                  "isDisabled": false,
                  "shouldAnimate": true
                },
                {
                  "ticker": "NIFTY",
                  "timeFrame": "Next Month",
                  "timeline": "08-02-2025 to 07-03-2025",
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
