const optionsTypeForm = {
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
            "title": "",
            "prompt":
                "As you've learned when to take an options trade, let's now look at how to place the order. Select the correct strike price from the available options to execute the trade.",
            "widget": "AnimatedText",
            "imageUrl": "assets/axis_logo.png",
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "prompt": "",
            "widget": "OptionChain",
            "optionData": {
              "options": {
                "call": {
                  "entries": [
                    {"premium": 231.50, "value": 235.70, "strike": 23050.00},
                    {"premium": 232.75, "value": 240.10, "strike": 23150.00},
                    {"premium": 234.25, "value": 243.90, "strike": 23250.00},
                    {"premium": 238.50, "value": 244.75, "strike": 23350.00}
                  ]
                },
                "put": {
                  "entries": [
                    {"premium": 230.95, "value": 231.49, "strike": 23050.00},
                    {"premium": 233.10, "value": 239.20, "strike": 23150.00},
                    {"premium": 237.75, "value": 242.99, "strike": 23250.00},
                    {"premium": 241.95, "value": 244.50, "strike": 23350.00}
                  ]
                }
              }
            }
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {"title": "", "widget": "TradeSheet"},
          {
            "title": "Next",
            "action": "moveToNextStep",
            "widget": "NextButtonWidget"
          }
        ],
      },
      {
        "stepId": "2",
        "isActionNeeded": false,
        "ui": [
          {
            "title": "",
            "prompt":
                "As you can see below, your market order has been executed immediately with the desired quantity.",
            "widget": "AnimatedText",
            "imageUrl": "assets/axis_logo.png",
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "title": "",
            "prompt": "",
            "widget": "OptionChain",
            "optionData": {
              "options": {
                "call": {
                  "entries": [
                    {"premium": 231.50, "value": 235.70, "strike": 23050.00},
                    {"premium": 232.75, "value": 240.10, "strike": 23150.00},
                    {"premium": 234.25, "value": 243.90, "strike": 23250.00},
                    {"premium": 238.50, "value": 244.75, "strike": 23350.00}
                  ]
                },
                "put": {
                  "entries": [
                    {"premium": 230.95, "value": 231.49, "strike": 23050.00},
                    {"premium": 233.10, "value": 239.20, "strike": 23150.00},
                    {"premium": 237.75, "value": 242.99, "strike": 23250.00},
                    {"premium": 241.95, "value": 244.50, "strike": 23350.00}
                  ]
                }
              }
            }
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {"widget": "OptionTradeSheet"},
          {
            "title": "Next",
            "action": "moveToNextStep",
            "widget": "NextButtonWidget"
          }
        ],
      },
      {
        "stepId": "3",
        "isActionNeeded": false,
        "ui": [
          {
            "title": "",
            "prompt":
                "Since the market has been bullish, your call option position is profitable. You can see how the price movement on the chart directly impacts your position P&L",
            "widget": "AnimatedText",
            "imageUrl": "assets/axis_logo.png",
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {
            "widget": "HorizontalLineChart",
            "chart": {
              "_id": "6409e70e91aaaefdcd7f8ff5",
              "qqid": 1840,
              "level": "u2_c1_l2",
              "ticker": "HDFC",
              "timeframe": "Daily",
              "startTime": 1623897000000,
              "atTime": 1623897000000,
              "endTime": 1626316200000,
              "type": "HorizontalLine_STATIC",
              "question": "How does the stock react when it touches 796 price?",
              "options": ["👆", "👇"],
              "correctResponse": "👇",
              "isReadyForProd": false,
              "leftColumn": null,
              "rangeResponse": null,
              "rangeResponses": [
                {"min": 791.6100083791081, "max": 804.6}
              ],
              "rightColumn": null,
              "selectedCandleIds": null,
              "bucket": "w8",
              "showChips": true,
              "candleSpeed": 200,
              "candles": [
                {
                  "_id": "6267f82983b67deb148c323c",
                  "num": 1,
                  "ticker": "ITC",
                  "time": 1634897400000,
                  "open": 236.6,
                  "high": 236.6,
                  "low": 236.6,
                  "close": 236.6,
                  "vol": 10
                },
                {
                  "_id": "6267f82983b67deb148c3240",
                  "num": 2,
                  "ticker": "ITC",
                  "time": 1634901900000,
                  "open": 236.6,
                  "high": 236.6,
                  "low": 236.6,
                  "close": 236.6,
                  "vol": 10
                },
                {
                  "_id": "6267f82983b67deb148c3241",
                  "num": 3,
                  "ticker": "ITC",
                  "time": 1635132900000,
                  "open": 234.85,
                  "high": 235.35,
                  "low": 232,
                  "close": 234.2,
                  "vol": 10.75
                },
                {
                  "_id": "6267f82983b67deb148c3245",
                  "num": 4,
                  "ticker": "ITC",
                  "time": 1635134400000,
                  "open": 234.15,
                  "high": 236.05,
                  "low": 230.5,
                  "close": 234.8,
                  "vol": 10.04999999999998
                },
                {
                  "_id": "6267f82983b67deb148c3251",
                  "num": 5,
                  "ticker": "ITC",
                  "time": 1635138000000,
                  "open": 234.8,
                  "high": 236.65,
                  "low": 234.6,
                  "close": 235.5,
                  "vol": 11.19999999999999
                },
                {
                  "_id": "6267f82983b67deb148c325d",
                  "num": 6,
                  "ticker": "ITC",
                  "time": 1635141600000,
                  "open": 235.5,
                  "high": 236,
                  "low": 233.9,
                  "close": 234.35,
                  "vol": 10.30000000000001
                },
                {
                  "_id": "6267f82983b67deb148c3269",
                  "num": 7,
                  "ticker": "ITC",
                  "time": 1635145200000,
                  "open": 234.15,
                  "high": 234.65,
                  "low": 233.5,
                  "close": 234,
                  "vol": 10.15000000000001
                },
                {
                  "_id": "6267f82983b67deb148c3275",
                  "num": 8,
                  "ticker": "ITC",
                  "time": 1635148800000,
                  "open": 234,
                  "high": 234.75,
                  "low": 233.3,
                  "close": 233.5,
                  "vol": 10.05000000000001
                },
                {
                  "_id": "6267f82983b67deb148c3281",
                  "num": 9,
                  "ticker": "ITC",
                  "time": 1635152400000,
                  "open": 233.5,
                  "high": 234.35,
                  "low": 232.5,
                  "close": 233,
                  "vol": 10.05000000000001
                },
                {
                  "_id": "6267f82983b67deb148c328d",
                  "num": 10,
                  "ticker": "ITC",
                  "time": 1635156000000,
                  "open": 233.55,
                  "high": 233.55,
                  "low": 233.4,
                  "close": 233.4,
                  "vol": 10.15000000000001
                },
                {
                  "_id": "6267f82983b67deb148c3293",
                  "num": 11,
                  "ticker": "ITC",
                  "time": 1635161100000,
                  "open": 233.4,
                  "high": 233.4,
                  "low": 233.4,
                  "close": 233.4,
                  "vol": 10
                },
                {
                  "_id": "6267f82983b67deb148c3294",
                  "num": 12,
                  "ticker": "ITC",
                  "time": 1635219300000,
                  "open": 234,
                  "high": 236.45,
                  "low": 233.95,
                  "close": 236.15,
                  "vol": 10.09999999999999
                },
                {
                  "_id": "6267f82983b67deb148c3299",
                  "num": 13,
                  "ticker": "ITC",
                  "time": 1635220800000,
                  "open": 236.15,
                  "high": 237.3,
                  "low": 234.7,
                  "close": 235.55,
                  "vol": 10.34999999999999
                },
                {
                  "_id": "6267f82983b67deb148c32a5",
                  "num": 14,
                  "ticker": "ITC",
                  "time": 1635224400000,
                  "open": 235.7,
                  "high": 235.9,
                  "low": 233.6,
                  "close": 234.25,
                  "vol": 10.10000000000002
                },
                {
                  "_id": "6267f82983b67deb148c32b1",
                  "num": 15,
                  "ticker": "ITC",
                  "time": 1635228000000,
                  "open": 234.4,
                  "high": 234.8,
                  "low": 234.6,
                  "close": 234.55,
                  "vol": 10.40000000000001
                },
                {
                  "_id": "6267f82983b67deb148c32bd",
                  "num": 16,
                  "ticker": "ITC",
                  "time": 1635231600000,
                  "open": 236.7,
                  "high": 236.9,
                  "low": 235.6,
                  "close": 235.25,
                  "vol": 10.25
                },
                {
                  "_id": "6267f82983b67deb148c32c9",
                  "num": 17,
                  "ticker": "ITC",
                  "time": 1635235200000,
                  "open": 235,
                  "high": 236.45,
                  "low": 234.95,
                  "close": 236.15,
                  "vol": 10.14999999999998
                },
                {
                  "_id": "6267f82983b67deb148c32d5",
                  "num": 18,
                  "ticker": "ITC",
                  "time": 1635238800000,
                  "open": 236.2,
                  "high": 238.9,
                  "low": 237,
                  "close": 238.9,
                  "vol": 10.15000000000001
                },
                {
                  "_id": "6267f82983b67deb148c32e1",
                  "num": 19,
                  "ticker": "ITC",
                  "time": 1635242400000,
                  "open": 238.85,
                  "high": 238.85,
                  "low": 236.7,
                  "close": 236.7,
                  "vol": 12.15000000000001
                },
                {
                  "_id": "6267f82983b67deb148c32e6",
                  "num": 20,
                  "ticker": "ITC",
                  "time": 1635247500000,
                  "open": 236.7,
                  "high": 236.7,
                  "low": 236.7,
                  "close": 236.7,
                  "vol": 10
                },
                {
                  "_id": "6267f82983b67deb148c32e7",
                  "num": 21,
                  "ticker": "ITC",
                  "time": 1635305700000,
                  "open": 240,
                  "high": 240.35,
                  "low": 237.3,
                  "close": 237.85,
                  "vol": 10.25
                },
                {
                  "_id": "6267f82983b67deb148c32eb",
                  "num": 22,
                  "ticker": "ITC",
                  "time": 1635307200000,
                  "open": 237.9,
                  "high": 240.25,
                  "low": 237.1,
                  "close": 238.55,
                  "vol": 10.20000000000002
                },
                {
                  "_id": "6267f82983b67deb148c32f7",
                  "num": 23,
                  "ticker": "ITC",
                  "time": 1635310800000,
                  "open": 238.55,
                  "high": 241.2,
                  "low": 237.7,
                  "close": 240.8,
                  "vol": 10.10000000000002
                },
                {
                  "_id": "6267f82983b67deb148c3303",
                  "num": 24,
                  "ticker": "ITC",
                  "time": 1635314400000,
                  "open": 240.75,
                  "high": 240.85,
                  "low": 239.3,
                  "close": 240.35,
                  "vol": 10.84999999999999
                },
                {
                  "_id": "6267f82983b67deb148c330f",
                  "num": 25,
                  "ticker": "ITC",
                  "time": 1635318000000,
                  "open": 240.35,
                  "high": 241,
                  "low": 240.2,
                  "close": 240.6,
                  "vol": 10.04999999999998
                },
                {
                  "_id": "6267f82983b67deb148c331b",
                  "num": 26,
                  "ticker": "ITC",
                  "time": 1635321600000,
                  "open": 237.55,
                  "high": 240.45,
                  "low": 237.55,
                  "close": 238.7,
                  "vol": 12.19999999999999
                },
                {
                  "_id": "6267f82983b67deb148c3327",
                  "num": 27,
                  "ticker": "ITC",
                  "time": 1635325200000,
                  "open": 238.8,
                  "high": 239.1,
                  "low": 237.9,
                  "close": 239,
                  "vol": 10.40000000000001
                },
                {
                  "_id": "6267f82983b67deb148c3333",
                  "num": 28,
                  "ticker": "ITC",
                  "time": 1635328800000,
                  "open": 238.4,
                  "high": 238.45,
                  "low": 238.4,
                  "close": 238.45,
                  "vol": 10.04999999999998
                },
                {
                  "_id": "6267f82983b67deb148c3338",
                  "num": 29,
                  "ticker": "ITC",
                  "time": 1635333900000,
                  "open": 238.45,
                  "high": 238.45,
                  "low": 238.45,
                  "close": 238.45,
                  "vol": 10
                }
              ],
              "notifyAnswered": false,
              "helperText":
                  "As stock is currently hovering around a previously established resistance level, there is a strong likelihood of an downward price movement from this point."
            }
          },
          {"width": "", "height": "40", "widget": "SizedBox"},
          {"widget": "OrderStatusWidget"},
          {
            "title": "Next",
            "action": "showSummaryBottomSheet",
            "prompt":
                "# **Summary**\n To take an options trade:\n - Buy a **call option** when there’s a **positive trendline** and the stock is at **support**.\n - Consider buying when a **bullish trend** is in place and a **breakout** is visible.\n - Look for a **positive trendline** with a **minor correction** at support, signaling a good entry point.",
            "widget": "NextButtonWidget"
          }
        ],
      }
    ],
  }
};
