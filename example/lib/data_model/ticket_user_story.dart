const ticketUserStory = {
  "userStory": {
    "id": "",
    "name": "",
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
                "Want to learn how options work? Let's explore it through concert ticket reservations!"
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
                "Let's suppose you purchase a weekly or monthly concert ticket by paying just the booking amount.\\\n\\\nSelect a ticket you would like to purchase"
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "CustomMCQWidget",
            "format": "column",
            "question": "",
            "ui": [
              {
                "widget": "CouponWidget",
                "ticketModel": {
                  "title": "Monthly Ticket",
                  "infoModel": [
                    {"title": "Booking Price", "amount": "100"},
                    {"title": "Concert Price", "amount": "500"},
                  ],
                  "color":"0xffFFE2AA"
                }
              },
              {
                "widget": "CouponWidget",
                "ticketModel": {
                  "title": "Weekly Ticket",
                  "infoModel": [
                    {"title": "Booking Price", "amount": "100"},
                    {"title": "Concert Price", "amount": "500"},
                  ],
                  "color":"0xffDFE6AA"
                },
              },
            ]
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "moveToNextStep"
          }
        ],
        "action": "selectedOption(string)",
        "isActionNeeded": true
      },
      {
        "stepId": "3",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "imageUrl": "assets/axis_logo.png",
            "prompt":
                "News is out, Drake is going to give a special appearance! Your weekly concert tickets are not being sold at **1000**"
          },
          {
            "widget": "CouponWidget",
            "ticketModel": {
              "title": "Weekly Ticket",
              "infoModel": [
                {"title": "Booking Price", "amount": "100"},
                {"title": "Concert Price"},
                {
                  "title": "For you",
                  "amount": "500",
                  "subtext": "Since you booked"
                },
                {
                  "title": "For others",
                  "amount": "1000",
                  "subtext": "Those that did not book"
                },
              ],
              "color":"0xffFFE2AA"
            }
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
            "prompt":
                "News is out, Drake is going to give a special appearance! Your weekly concert tickets are not being sold at **1000**"
          },
          {
            "widget": "CouponWidget",
            "ticketModel": {
              "title": "Weekly Ticket",
              "infoModel": [
                {"title": "Booking Price", "amount": "100"},
                {"title": "Concert Price"},
                {"title": "For you", "amount": "500"},
                {"title": "For others", "amount": "1000"},
              ],
              "color":"0xffFFE2AA"
            }
          },
          {
            "widget": "CustomMCQWidget",
            "format": "row",
            "question": "",
            "ui": [
              {
                "widget": "MarkdownText",
                "title": "",
                "prompt":
                    "**Buy the ticket for 500**\\\n\\\nand\\\n\\\n**Sell the ticket for 1000**",
              },
              {
                "widget": "MarkdownText",
                "title": "",
                "prompt":
                    "**Let the reservation expire**\\\n\\\nand\\\n\\\n**Loose booking charges of 100**",
              },
            ],
            "action": "",
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
                "Just like in the market, you paid a **premium** (the ticket reservation) for a chance to **exercise the option** (buy tickets)."
          },
          {
            "widget": "PlainText",
            "prompt": "# **Whoppie! You made** \n # **a profit of 900**"
          },
          {
            "widget": "ImageWidget",
            "imageUrl":
                "https://tradeable-cms.s3.ap-south-1.amazonaws.com/coin_box.png",
            "height": "400"
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
                "If the price went up, you made a profit.\\\nIf it didn't, you lost your reservation fee of 100"
          },
          {
            "widget": "PlainText",
            "prompt": "# **Whoppie! You made** \n # **a profit of 900**"
          },
          {
            "widget": "ImageWidget",
            "imageUrl":
                "https://tradeable-cms.s3.ap-south-1.amazonaws.com/coin_box.png",
            "height": "400"
          },
          {"widget": "NextButtonWidget", "title": "Next", "action": "moveNext"}
        ],
        "isActionNeeded": false
      },
    ]
  }
};
