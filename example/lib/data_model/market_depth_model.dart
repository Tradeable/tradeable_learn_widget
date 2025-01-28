const marketDepthModel = {
  "userStory": {
    "id": "",
    "name": "",
    "type": "market_depth_user_story",
    "steps": [
      {
        "ui": [
          {
            "title": "",
            "prompt":
                "What is higher in the current market as per the given data points?",
            "widget": "AnimatedText"
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "prompt": "",
            "widget": "MarketDepthTable",
            "tableData": {
              "data": [
                {
                  "data": [
                    {"price": "653.35", "orders": "2", "quantity": "500"},
                    {"price": "653.30", "orders": "4", "quantity": "595"},
                    {"price": "653.25", "orders": "9", "quantity": "771"},
                    {"price": "653.20", "orders": "6", "quantity": "2003"},
                    {"price": "653.15", "orders": "8", "quantity": "3658"}
                  ],
                  "title": "Bid Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xFFFDDACD", "0xffFF7E55"]
                },
                {
                  "data": [
                    {"price": "653.40", "orders": "3", "quantity": "15"},
                    {"price": "653.45", "orders": "5", "quantity": "8"},
                    {"price": "653.50", "orders": "6", "quantity": "10"},
                    {"price": "653.55", "orders": "7", "quantity": "12"},
                    {"price": "653.60", "orders": "10", "quantity": "2"}
                  ],
                  "title": "Ask Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xffCFDA81", "0xff98B900"]
                }
              ],
              "tableAlignment": "horizontal"
            },
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "format": "grid",
            "widget": "MCQQuestion",
            "options": ["Demand", "Supply"],
            "correctResponse": ["Demand"]
          },
          {
            "title": "Next",
            "action": "submitResponse",
            "widget": "NextButtonWidget"
          }
        ],
        "stepId": "1",
        "isActionNeeded": true,
      },
      {
        "ui": [
          {
            "title": "",
            "prompt": "How will market behave as per higher demand?",
            "widget": "AnimatedText"
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "prompt": "",
            "widget": "MarketDepthTable",
            "tableData": {
              "data": [
                {
                  "data": [
                    {"price": "653.35", "orders": "2", "quantity": "500"},
                    {"price": "653.30", "orders": "4", "quantity": "595"},
                    {"price": "653.25", "orders": "9", "quantity": "771"},
                    {"price": "653.20", "orders": "6", "quantity": "2003"},
                    {"price": "653.15", "orders": "8", "quantity": "3658"}
                  ],
                  "title": "Bid Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xFFFDDACD", "0xffFF7E55"]
                },
                {
                  "data": [
                    {"price": "653.40", "orders": "3", "quantity": "15"},
                    {"price": "653.45", "orders": "5", "quantity": "8"},
                    {"price": "653.50", "orders": "6", "quantity": "10"},
                    {"price": "653.55", "orders": "7", "quantity": "12"},
                    {"price": "653.60", "orders": "10", "quantity": "2"}
                  ],
                  "title": "Ask Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xffCFDA81", "0xff98B900"]
                }
              ],
              "tableAlignment": "horizontal"
            },
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "format": "grid",
            "widget": "MCQQuestion",
            "options": ["Bullish", "Bearish"],
            "correctResponse": ["Bullish"]
          },
          {
            "title": "Next",
            "action": "submitResponse",
            "widget": "NextButtonWidget"
          }
        ],
        "stepId": "2",
        "isActionNeeded": true
      },
      {
        "ui": [
          {
            "title": "",
            "prompt":
                "As per the given stock price, place a limit order and add preferred quantity to analyse how ask & bid works.",
            "widget": "AnimatedText"
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "prompt": "",
            "widget": "MarketDepthTable",
            "tableData": {
              "data": [
                {
                  "data": [
                    {"price": "653.35", "orders": "2", "quantity": "500"},
                    {"price": "653.30", "orders": "4", "quantity": "595"},
                    {"price": "653.25", "orders": "9", "quantity": "771"},
                    {"price": "653.20", "orders": "6", "quantity": "2003"},
                    {"price": "653.15", "orders": "8", "quantity": "3658"}
                  ],
                  "title": "Bid Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xFFFDDACD", "0xffFF7E55"]
                },
                {
                  "data": [
                    {"price": "653.40", "orders": "3", "quantity": "15"},
                    {"price": "653.45", "orders": "5", "quantity": "8"},
                    {"price": "653.50", "orders": "6", "quantity": "10"},
                    {"price": "653.55", "orders": "7", "quantity": "12"},
                    {"price": "653.60", "orders": "10", "quantity": "2"}
                  ],
                  "title": "Ask Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xffCFDA81", "0xff98B900"]
                }
              ],
              "tableAlignment": "horizontal"
            },
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {"title": "", "widget": "TradeSheet"},
          {
            "title": "Place Order",
            "action": "showBottomSheet",
            "widget": "NextButtonWidget"
          }
        ],
        "stepId": "3",
        "isActionNeeded": false
      },
      {
        "ui": [
          {
            "title": "",
            "prompt":
                "As you can see the order you placed is currently an pending position which will be placed after all ask prices above are executed",
            "widget": "AnimatedText"
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "prompt": "",
            "widget": "MarketDepthTable",
            "tableData": {
              "data": [
                {
                  "data": [
                    {"price": "653.35", "orders": "2", "quantity": "500"},
                    {"price": "653.30", "orders": "4", "quantity": "595"},
                    {"price": "653.25", "orders": "9", "quantity": "771"},
                    {"price": "653.20", "orders": "6", "quantity": "2003"},
                    {"price": "653.15", "orders": "8", "quantity": "3658"}
                  ],
                  "title": "Bid Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xFFFDDACD", "0xffFF7E55"]
                },
                {
                  "data": [
                    {"price": "653.40", "orders": "3", "quantity": "15"},
                    {"price": "653.45", "orders": "5", "quantity": "8"},
                    {"price": "653.50", "orders": "6", "quantity": "10"},
                    {"price": "653.55", "orders": "7", "quantity": "12"},
                    {"price": "653.60", "orders": "10", "quantity": "2"}
                  ],
                  "title": "Ask Price",
                  "totalValue": "9,21,678",
                  "tableColors": ["0xffCFDA81", "0xff98B900"]
                }
              ],
              "tableAlignment": "horizontal"
            },
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {"title": "BANKNIFTY2003CE", "widget": "TradeInfo"},
          {"title": "Next", "action": "moveNext", "widget": "NextButtonWidget"}
        ],
        "stepId": "4",
        "isActionNeeded": false
      }
    ],
    "description": ""
  }
};
