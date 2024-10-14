import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/risk_reward_ratio_widget/risk_reward_ratio_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class RiskRewardRatioWidget extends StatefulWidget {
  final RiskRewardRatioModel model;

  const RiskRewardRatioWidget({super.key, required this.model});

  @override
  State<RiskRewardRatioWidget> createState() => _RiskRewardRatioWidgetState();
}

class _RiskRewardRatioWidgetState extends State<RiskRewardRatioWidget> {
  int riskIndex = 0;
  int rewardIndex = 0;
  late RiskRewardRatioModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    rewardIndex = model.riskLevels.length - 1 - riskIndex;
  }

  void updateRiskSlider(double value) {
    setState(() {
      riskIndex = value.toInt();
      rewardIndex = model.riskLevels.length - 1 - riskIndex;
    });
  }

  void updateRewardSlider(double value) {
    setState(() {
      rewardIndex = value.toInt();
      riskIndex = model.riskLevels.length - 1 - rewardIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          model.title,
          style: textStyles.largeBold,
        ),
        const SizedBox(height: 10),
        Text(
          model.description,
          textAlign: TextAlign.center,
          style: textStyles.mediumNormal,
        ),
        const SizedBox(height: 30),
        Text('Risk: ${model.riskLevels[riskIndex]}'),
        Slider(
          value: riskIndex.toDouble(),
          min: 0,
          max: (model.riskLevels.length - 1).toDouble(),
          divisions: model.riskLevels.length - 1,
          label: model.riskLevels[riskIndex],
          onChanged: updateRiskSlider,
        ),
        const SizedBox(height: 20),
        Text(
            'Reward: ${model.rewardRanges[widget.model.riskLevels[rewardIndex]]}'),
        Slider(
          value: rewardIndex.toDouble(),
          min: 0,
          max: (model.riskLevels.length - 1).toDouble(),
          divisions: model.riskLevels.length - 1,
          label: model.rewardRanges[widget.model.riskLevels[rewardIndex]],
          onChanged: updateRewardSlider,
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderColorSecondary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DataTable(
            border: TableBorder.all(color: colors.borderColorSecondary),
            columns: const [
              DataColumn(label: Text('Risk Level')),
              DataColumn(label: Text('Reward Range')),
            ],
            rows: model.riskLevels
                .map((risk) => DataRow(cells: [
                      DataCell(Text(risk)),
                      DataCell(Text(model.rewardRanges[risk]!)),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
  }
}
