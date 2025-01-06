import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/demand_supply_educorner/demand_supply_educorner_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
        Text(
          'Demand: ${currentBidCondition!.demand}',
          style: textStyles.mediumNormal,
        ),
        Text(
          'Supply: ${currentAskCondition!.supply}',
          style: textStyles.mediumNormal,
        ),
        Text(
          'Market: ${currentBidCondition!.market}',
          style: textStyles.mediumNormal,
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
                label: currentBidCondition?.bidPrice,
                thumbColor: colors.primary,
                activeColor: colors.primary,
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
                thumbColor: colors.primary,
                activeColor: colors.primary,
                inactiveColor: colors.cardColorPrimary,
                divisions: marketCondition.length - 1,
                label: currentAskCondition?.askPrice,
                onChanged: (value) {
                  setState(() {
                    askSliderValue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
