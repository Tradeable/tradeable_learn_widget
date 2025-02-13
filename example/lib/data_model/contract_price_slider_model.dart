const contractPriceSliderModel = {
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
                "As the expiry comes nearer, price of the given contract fluctuates."
          },
          {"widget": "SizedBox", "height": "30"},
          {
            "widget": "CustomSlider",
            "sliderData": {
              "title": "NIFTY",
              "subtext": "This Week",
              "showDivision": true,
              "sliderPoints": [
                {
                  "contract_price": 250.5,
                  "volatility": 0.25,
                  "theta": -0.03,
                  "delta": 0.65
                },
                {
                  "contract_price": 180.75,
                  "volatility": 0.32,
                  "theta": -0.05,
                  "delta": 0.72
                },
                {
                  "contract_price": 310.2,
                  "volatility": 0.28,
                  "theta": -0.04,
                  "delta": 0.58
                },
                {
                  "contract_price": 95.4,
                  "volatility": 0.40,
                  "theta": -0.07,
                  "delta": 0.80
                },
                {
                  "contract_price": 420.9,
                  "volatility": 0.22,
                  "theta": -0.02,
                  "delta": 0.50
                }
              ]
            }
          },
          {
            "widget": "SizedBox",
            "height": "60",
            "width": "",
          },
          {"widget": "NextButtonWidget", "title": "Next", "action": "moveNext"}
        ],
        "isActionNeeded": false
      },
    ]
  }
};
