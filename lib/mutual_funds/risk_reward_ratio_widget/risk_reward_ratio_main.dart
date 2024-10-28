import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/risk_reward_ratio_widget/risk_reward_ratio_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class RiskRewardRatioWidget extends StatefulWidget {
  final RiskRewardRatioModel model;

  const RiskRewardRatioWidget({Key? key, required this.model})
      : super(key: key);

  @override
  State<RiskRewardRatioWidget> createState() => _RiskRewardRatioWidgetState();
}

class _RiskRewardRatioWidgetState extends State<RiskRewardRatioWidget> {
  int riskIndex = 0;
  late RiskRewardRatioModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  void updateSlider(double value) {
    setState(() {
      riskIndex = value.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.title, style: textStyles.smallBold),
                  const SizedBox(height: 5),
                  Text(model.description, style: textStyles.mediumNormal),
                  const SizedBox(height: 30),
                  _buildRiskRow(textStyles),
                  const SizedBox(height: 30),
                  _buildBagImages(),
                  const SizedBox(height: 10),
                  _buildSlider(context, colors),
                  const SizedBox(height: 20),
                  _buildRewardRow(textStyles),
                  const SizedBox(height: 20),
                  _buildFundDetailsContainer(textStyles, colors),
                ],
              ),
            ),
          ),
          _buildNextButton(colors),
        ],
      ),
    );
  }

  Row _buildRiskRow(CustomStyles textStyles) {
    return Row(
      children: [
        Text('Risk: ', style: textStyles.mediumNormal),
        Text(
          model.riskLevels[riskIndex],
          style:
              textStyles.mediumBold.copyWith(color: getSliderColor(riskIndex)),
        ),
      ],
    );
  }

  Row _buildRewardRow(CustomStyles textStyles) {
    return Row(
      children: [
        Text('Reward: ', style: textStyles.mediumNormal),
        Text(
          model.riskLevels[riskIndex],
          style:
              textStyles.mediumBold.copyWith(color: getSliderColor(riskIndex)),
        ),
      ],
    );
  }

  Row _buildBagImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Image.asset(
          getBagImage(index),
          height: 60,
          width: 60,
          package: 'tradeable_learn_widget/lib',
        );
      }),
    );
  }

  SliderTheme _buildSlider(BuildContext context, CustomColors colors) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        activeTrackColor: getSliderColor(riskIndex),
        inactiveTrackColor: Colors.grey[300],
        thumbColor: colors.borderColorSecondary,
        overlayColor: Colors.blue.withOpacity(0.2),
        valueIndicatorColor: Colors.blue,
      ),
      child: Slider(
        value: riskIndex.toDouble(),
        min: 0,
        max: 3,
        divisions: 3,
        label: model.riskLevels[riskIndex],
        onChanged: updateSlider,
      ),
    );
  }

  Container _buildFundDetailsContainer(
      CustomStyles textStyles, CustomColors colors) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.borderColorSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoButton(context),
          ..._buildFundDetailsList(textStyles, colors),
        ],
      ),
    );
  }

  Align _buildInfoButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => _showFundDialog(context),
        icon: const Icon(Icons.info_outline),
      ),
    );
  }

  void _showFundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    _buildDialogRow(
                        'Fund Name',
                        model.fundDetails.firstWhere((fund) =>
                            fund['Risk Category'] ==
                            model.riskLevels[riskIndex])['Mutual Fund Type']!),
                    _buildDialogRow('Risk Rating', model.riskLevels[riskIndex]),
                    _buildAverageReturnsRow(context),
                    const SizedBox(height: 30)
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFundDetailsList(
      CustomStyles textStyles, CustomColors colors) {
    return model.fundDetails
        .where((fund) => fund['Risk Category'] == model.riskLevels[riskIndex])
        .map((fund) {
      final avgReturnsText = fund['Average Returns (%)']!;
      final isNumericRange = avgReturnsText.contains('-') &&
          avgReturnsText.split('-').every((part) =>
              double.tryParse(part.replaceAll('%', '').trim()) != null);

      double? progress;
      if (isNumericRange) {
        final avgReturnRange = avgReturnsText.split('-');
        final minReturn =
            double.parse(avgReturnRange.first.replaceAll('%', '').trim());
        final maxReturn =
            double.parse(avgReturnRange.last.replaceAll('%', '').trim());
        progress = ((minReturn + maxReturn) / 2) / 100;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fund['Mutual Fund Type']!, style: textStyles.mediumNormal),
            Text(
              model.riskLevels[riskIndex],
              style: textStyles.smallBold.copyWith(
                color: getSliderColor(riskIndex),
              ),
            ),
            const SizedBox(height: 4),
            if (isNumericRange)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: colors.borderColorSecondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: getSliderColor(riskIndex),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(avgReturnsText, style: textStyles.smallNormal),
                ],
              ),
            const SizedBox(height: 4),
          ],
        ),
      );
    }).toList();
  }

  Row _buildDialogRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value),
        Text(label, style: Theme.of(context).customTextStyles.smallNormal),
      ],
    );
  }

  Row _buildAverageReturnsRow(BuildContext context) {
    final fund = model.fundDetails.firstWhere(
        (fund) => fund['Risk Category'] == model.riskLevels[riskIndex]);
    final avgReturnsText = fund['Average Returns (%)']!;
    final isNumericRange = avgReturnsText.contains('-') &&
        avgReturnsText.split('-').every(
            (part) => double.tryParse(part.replaceAll('%', '').trim()) != null);

    double? progress;
    if (isNumericRange) {
      final avgReturnRange = avgReturnsText.split('-');
      final minReturn =
          double.parse(avgReturnRange.first.replaceAll('%', '').trim());
      final maxReturn =
          double.parse(avgReturnRange.last.replaceAll('%', '').trim());
      progress = ((minReturn + maxReturn) / 2) / 100;
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .customColors
                  .borderColorSecondary
                  .withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress ?? 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: getSliderColor(riskIndex),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text("Average returns",
            style: Theme.of(context).customTextStyles.smallNormal),
      ],
    );
  }

  Container _buildNextButton(CustomColors colors) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(10),
      child: ButtonWidget(
        color: colors.primary,
        btnContent: "Next",
        onTap: () {},
      ),
    );
  }

  String getBagImage(int index) {
    switch (index) {
      case 0:
        return "assets/risk_reward_ratio/redbag.png";
      case 1:
      case 2:
        return "assets/risk_reward_ratio/yellowbag.png";
      case 3:
        return "assets/risk_reward_ratio/greenbag.png";
      default:
        return "assets/risk_reward_ratio/redbag.png";
    }
  }

  Color getSliderColor(int index) {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orangeAccent;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
