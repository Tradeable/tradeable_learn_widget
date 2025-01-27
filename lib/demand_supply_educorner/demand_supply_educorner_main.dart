import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/demand_supply_educorner/demand_supply_educorner_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

  @override
  void initState() {
    super.initState();
    marketCondition = widget.model.marketCondition;
  }

  int get bidConditionIndex =>
      ((bidSliderValue * (marketCondition.length - 1)).round());

  int get askConditionIndex =>
      ((askSliderValue * (marketCondition.length - 1)).round());

  MarketCondition? get currentBidCondition =>
      marketCondition.isNotEmpty ? marketCondition[bidConditionIndex] : null;

  MarketCondition? get currentAskCondition =>
      marketCondition.isNotEmpty ? marketCondition[askConditionIndex] : null;

  String get marketImage {
    if (currentBidCondition == null || currentAskCondition == null) {
      return '';
    }

    if (bidSliderValue > 0.5 && askSliderValue < 0.5) {
      return "assets/supply_demand_educorner/bullish.png";
    } else if (bidSliderValue < 0.5 && askSliderValue > 0.5) {
      return "assets/supply_demand_educorner/bearish.png";
    } else if (bidSliderValue > 0.5 && askSliderValue > 0.5) {
      return "assets/supply_demand_educorner/bullish.png";
    } else if (bidSliderValue < 0.5 && askSliderValue < 0.5) {
      return "assets/supply_demand_educorner/bearish.png";
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/market_depth/profile_guy.png",
              package: 'tradeable_learn_widget/lib',
              height: 140,
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Markdown(
              data: widget.model.introMd,
              shrinkWrap: true,
            )),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            infoWidget("Demand", getDemandText()),
            infoWidget("Supply", getSupplyText()),
            infoWidget("Market", getMarketCondition()),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Bid Price', style: textStyles.mediumNormal),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.info_outline))
                ],
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
                  });
                },
              ),
              Row(
                children: [
                  Text('Ask Price', style: textStyles.mediumNormal),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.info_outline))
                ],
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
              widget.onNextClick();
            },
          ),
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
