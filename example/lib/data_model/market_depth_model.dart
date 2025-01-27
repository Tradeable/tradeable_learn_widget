const marketDepthModel = {
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
            "prompt":
                "What is higher in the current market as per the given data points?",
          },
          {
            "widget": "SizedBox",
            "height": "40",
            "width": "",
          },
          {
            "widget": "MarketDepthTable",
            "title": "",
            "prompt": "",
            "tableAlignment": "horizontal",
            "tableData": [
              {
                "title": "Bid Price",
                "tableColors": ['0xFFFDDACD', '0xffFF7E55'],
                "data": [
                  {"price": "653.35", "orders": "2", "quantity": "103"},
                  {"price": "653.30", "orders": "4", "quantity": "595"},
                  {"price": "653.25", "orders": "9", "quantity": "771"},
                  {"price": "653.20", "orders": "6", "quantity": "2003"},
                  {"price": "653.15", "orders": "8", "quantity": "3658"}
                ],
                "totalValue": "9,21,678"
              },
              {
                "title": "Ask Price",
                "tableColors": ['0xffCFDA81', '0xff98B900'],
                "data": [
                  {"price": "653.40", "orders": "3", "quantity": "150"},
                  {"price": "653.45", "orders": "5", "quantity": "800"},
                  {"price": "653.50", "orders": "6", "quantity": "1023"},
                  {"price": "653.55", "orders": "7", "quantity": "1234"},
                  {"price": "653.60", "orders": "10", "quantity": "2000"}
                ],
                "totalValue": "9,21,678"
              }
            ]
          },
          {
            "widget": "MCQQuestion",
            "title": "",
            "format": "grid",
            "options": ["High Volume", "Low Volume"],
            "correctResponse": ["High Volume"]
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "submitResponse"
          }
        ],
        "isActionNeeded": true,
      },
      {
        "stepId": "2",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "prompt": "How will market behave as per higher demand?",
          },
          {
            "widget": "MarketDepthTable",
            "title": "",
            "prompt": "",
            "tableAlignment": "horizontal",
            "tableData": [
              {
                "title": "Bid Price",
                "tableColors": ['0xFFFDDACD', '0xffFF7E55'],
                "data": [
                  {"price": "653.35", "orders": "2", "quantity": "103"},
                  {"price": "653.30", "orders": "4", "quantity": "595"},
                  {"price": "653.25", "orders": "9", "quantity": "771"},
                  {"price": "653.20", "orders": "6", "quantity": "2003"},
                  {"price": "653.15", "orders": "8", "quantity": "3658"}
                ],
                "totalValue": "9,21,678"
              },
              {
                "title": "Ask Price",
                "tableColors": ['0xffCFDA81', '0xff98B900'],
                "data": [
                  {"price": "653.40", "orders": "3", "quantity": "150"},
                  {"price": "653.45", "orders": "5", "quantity": "800"},
                  {"price": "653.50", "orders": "6", "quantity": "1023"},
                  {"price": "653.55", "orders": "7", "quantity": "1234"},
                  {"price": "653.60", "orders": "10", "quantity": "2000"}
                ],
                "totalValue": "9,21,678"
              }
            ]
          },
          {
            "widget": "MCQQuestion",
            "title": "",
            "format": "grid",
            "options": ["Bullish", "Bearish"],
            "correctResponse": ["Bullish"]
          },
          {
            "widget": "NextButtonWidget",
            "title": "Next",
            "action": "submitResponse"
          }
        ],
        "isActionNeeded": true,
      },
      {
        "stepId": "3",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "prompt":
                "As per the given stock price, place a limit order and add preferred quantity to analyse how ask & bid works.",
          },
          {
            "widget": "MarketDepthTable",
            "title": "",
            "prompt": "",
            "tableAlignment": "vertical",
            "tableData": [
              {
                "title": "Bid Price",
                "tableColors": ['0xFFFDDACD', '0xffFF7E55'],
                "data": [
                  {"price": "653.35", "orders": "2", "quantity": "103"},
                  {"price": "653.30", "orders": "4", "quantity": "595"},
                  {"price": "653.25", "orders": "9", "quantity": "771"},
                  {"price": "653.20", "orders": "6", "quantity": "2003"},
                  {"price": "653.15", "orders": "8", "quantity": "3658"}
                ],
                "totalValue": "9,21,678"
              },
              {
                "title": "Ask Price",
                "tableColors": ['0xffCFDA81', '0xff98B900'],
                "data": [
                  {"price": "653.35", "orders": "3", "quantity": "150"},
                  {"price": "653.45", "orders": "5", "quantity": "800"},
                  {"price": "653.50", "orders": "6", "quantity": "1023"},
                  {"price": "653.55", "orders": "7", "quantity": "1234"},
                  {"price": "653.60", "orders": "10", "quantity": "2000"}
                ],
                "totalValue": "9,21,678"
              }
            ]
          },
          {"widget": "TradeSheet", "title": ""},
          {
            "widget": "NextButtonWidget",
            "title": "Confirm Order",
            "action": "confirmOrder"
          }
        ],
        "isActionNeeded": true,
      },
      {
        "stepId": "4",
        "ui": [
          {
            "widget": "AnimatedText",
            "title": "",
            "prompt":
                "As you can see the order you placed is currently an pending position which will be placed after all ask prices above are executed",
          },
          {
            "widget": "MarketDepthTable",
            "title": "",
            "prompt": "",
            "tableAlignment": "vertical",
            "tableData": [
              {
                "title": "Bid Price",
                "tableColors": ['0xFFFDDACD', '0xffFF7E55'],
                "data": [
                  {"price": "653.35", "orders": "2", "quantity": "103"},
                  {"price": "653.30", "orders": "4", "quantity": "595"},
                  {"price": "653.25", "orders": "9", "quantity": "771"},
                  {"price": "653.20", "orders": "6", "quantity": "2003"},
                  {"price": "653.15", "orders": "8", "quantity": "3658"}
                ],
                "totalValue": "9,21,678"
              },
              {
                "title": "Ask Price",
                "tableColors": ['0xffCFDA81', '0xff98B900'],
                "data": [
                  {"price": "653.35", "orders": "3", "quantity": "150"},
                  {"price": "653.45", "orders": "5", "quantity": "800"},
                  {"price": "653.50", "orders": "6", "quantity": "1023"},
                  {"price": "653.55", "orders": "7", "quantity": "1234"},
                  {"price": "653.60", "orders": "10", "quantity": "2000"}
                ],
                "totalValue": "9,21,678"
              }
            ]
          },
          {"widget": "TradeInfo", "title": "BANKNIFTY2003CE"},
          {"widget": "NextButtonWidget", "title": "Next", "action": "moveNext"}
        ],
        "isActionNeeded": false,
      }
    ]
  }
};
