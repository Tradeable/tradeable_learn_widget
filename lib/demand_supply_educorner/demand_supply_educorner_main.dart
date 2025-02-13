import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/demand_supply_educorner/demand_supply_educorner_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/animated_text_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class DemandSuplyEduCornerMain extends StatefulWidget {
  final DemandSupplyEduCornerModel model;
  final VoidCallback onNextClick;

  const DemandSuplyEduCornerMain(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<StatefulWidget> createState() => _DemandSuplyEduCornerMain();
}

class _DemandSuplyEduCornerMain extends State<DemandSuplyEduCornerMain> {
  double bidSliderValue = 0;
  double askSliderValue = 0;

  late final List<MarketCondition> marketCondition;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    marketCondition = widget.model.marketCondition;
    setSlidersBasedOnCondition(marketCondition[currentIndex]);
  }

  void setSlidersBasedOnCondition(MarketCondition condition) {
    setState(() {
      bidSliderValue = condition.bidPrice == "High" ? 1.0 : 0.0;
      askSliderValue = condition.askPrice == "Low" ? 0.0 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        AnimatedTextWidget(
            title: '',
            prompt: getExplanation(),
            logo: "assets/market_depth/profile_guy.png"),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            infoWidget("Demand", getDemandText()),
            infoWidget("Supply", getSupplyText()),
            infoWidget("Market", getMarketCondition()),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildPriceRow(
                context,
                title: 'Bid Price',
                infoTitle: 'Bid Price',
                infoContent:
                    "The bid price is the price at which a buyer is willing to purchase a security, asset, or commodity. In other words, it's the highest price that a buyer is prepared to pay for an asset at any given time.\nJust like the ask price, the bid price is a crucial part of market transactions. The bid price reflects the demand side of the market, while the ask price reflects the supply side.",
              ),
              Slider(
                value: bidSliderValue,
                min: 0,
                max: 1,
                divisions: marketCondition.length - 1,
                label: getDemandText(),
                thumbColor: colors.borderColorPrimary,
                activeColor: colors.borderColorPrimary,
                inactiveColor: colors.cardColorPrimary,
                onChanged: (value) {
                  setState(() {
                    bidSliderValue = value;
                    askSliderValue = 1 - value;
                  });
                },
              ),
              _buildPriceRow(
                context,
                title: 'Ask Price',
                infoTitle: 'Ask Price',
                infoContent:
                    "The ask price (also known as the offer price) is the price at which a seller is willing to sell a security, asset, or commodity. In financial markets, it's the price that a seller is asking for when they are offering to sell an asset. It represents the lowest price a seller is willing to accept for the asset at any given moment.",
              ),
              Slider(
                value: askSliderValue,
                min: 0,
                max: 1,
                thumbColor: colors.borderColorPrimary,
                activeColor: colors.borderColorPrimary,
                inactiveColor: colors.cardColorPrimary,
                divisions: marketCondition.length - 1,
                label: getSupplyText(),
                onChanged: (value) {
                  setState(() {
                    askSliderValue = value;
                    bidSliderValue = 1 - value;
                  });
                },
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: ButtonWidget(
            color: colors.primary,
            btnContent: "Next",
            onTap: () {
              if (currentIndex == 1) {
                widget.onNextClick();
              } else {
                setState(() {
                  currentIndex = (currentIndex + 1) % marketCondition.length;
                  setSlidersBasedOnCondition(marketCondition[currentIndex]);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context,
      {required String title,
      required String infoTitle,
      required String infoContent}) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Row(
      children: [
        Text(title, style: textStyles.smallNormal),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(infoTitle, style: textStyles.mediumBold),
                      const SizedBox(height: 10),
                      Text(infoContent, style: textStyles.smallNormal),
                      const SizedBox(height: 20),
                      ButtonWidget(
                        color: colors.primary,
                        btnContent: "Okay",
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.info_outline, size: 20),
        ),
      ],
    );
  }

  String getDemandText() {
    if (bidSliderValue > 0.5) {
      return 'Strong';
    } else {
      return 'Weak';
    }
  }

  String getSupplyText() {
    if (askSliderValue < 0.5) {
      return 'Low';
    } else if (askSliderValue > 0.5 && askSliderValue <= 0.8) {
      return 'Limited';
    } else {
      return 'High';
    }
  }

  String getExplanation() {
    switch (getMarketCondition()) {
      case "Bullish":
        return "As you can see when the bid is high and ask is low there is strong demand and low supply. This makes the market movement favour the bullish side.";
      case "Bearish":
        return "As you can see low bid and high ask which means there is weak demand and low supply. This makes the movement favour the bearish side.";

      default:
        return "";
    }
  }

  String getMarketCondition() {
    if (bidSliderValue > 0.5 && askSliderValue < 0.5) {
      return 'Bullish';
    } else if (bidSliderValue < 0.5 && askSliderValue > 0.5) {
      return 'Bearish';
    } else if (bidSliderValue > 0.5 && askSliderValue > 0.5) {
      return 'Bullish';
    } else if (bidSliderValue < 0.5 && askSliderValue < 0.5) {
      return 'Bearish';
    }
    return '';
  }

  Widget infoWidget(String heading, String content) {
    final textStyles = Theme.of(context).customTextStyles;
    return Column(
      children: [
        Text(
          heading,
          style: textStyles.smallNormal,
        ),
        Text(content, style: textStyles.mediumBold),
        const SizedBox(height: 10),
        if (heading == "Demand")
          Image.asset(
            content == "Strong"
                ? "assets/supply_demand_educorner/high_demand.png"
                : "assets/supply_demand_educorner/weak_demand.png",
            package: 'tradeable_learn_widget/lib',
            height: 35,
            fit: BoxFit.fitHeight,
          )
        else if (heading == "Supply")
          Image.asset(
            content == "High"
                ? "assets/supply_demand_educorner/high_supply.png"
                : "assets/supply_demand_educorner/low_supply.png",
            package: 'tradeable_learn_widget/lib',
            height: 35,
            fit: BoxFit.fitHeight,
          )
        else if (heading == "Market")
          Image.asset(
            content == "Bullish"
                ? "assets/supply_demand_educorner/bullish.png"
                : "assets/supply_demand_educorner/bearish.png",
            package: 'tradeable_learn_widget/lib',
            height: 35,
            fit: BoxFit.fitHeight,
          )
      ],
    );
  }
}
