import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/volume_price_text_data_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/volume_chart.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class VolumePriceSlider extends StatefulWidget {
  final String title;
  final String prompt;
  final List<VolumePriceTextData> textData;
  final List<Candle> candles;
  final Function(int) onSliderChanged;

  const VolumePriceSlider(
      {super.key,
      required this.title,
      required this.prompt,
      required this.textData,
      required this.candles,
      required this.onSliderChanged});

  @override
  State<VolumePriceSlider> createState() => _VolumePriceSliderState();
}

class _VolumePriceSliderState extends State<VolumePriceSlider> {
  int _sliderValue = 1;
  late List<Candle> candleData;

  @override
  void initState() {
    super.initState();
    candleData = widget.candles
        .map((candle) => Candle(
              candle.ticker,
              candle.candleNum,
              candle.time,
              candle.open,
              candle.high,
              candle.low,
              candle.close,
              candle.vol,
            ))
        .toList();
    manipulateCandles(0);
  }

  void manipulateCandles(int sliderValue) {
    setState(() {
      final redMultipliers = [2.4, 2.0, 0.9, 0.5];
      final greenMultipliers = [0.9, 1.3, 2.0, 2.4];

      candleData = widget.candles
          .map((candle) => Candle(
                candle.ticker,
                candle.candleNum,
                candle.time,
                candle.open,
                candle.high,
                candle.low,
                candle.close,
                candle.vol *
                    (candle.close < candle.open
                        ? redMultipliers[sliderValue]
                        : greenMultipliers[sliderValue]),
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentText = widget.textData[_sliderValue];
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VolumeBarChart(candles: candleData),
          Row(
            children: [
              Text("Price:", style: textStyles.smallNormal),
              const SizedBox(width: 10),
              Text(currentText.price, style: textStyles.smallBold),
              const Spacer(),
              Text("Volume:", style: textStyles.smallNormal),
              const SizedBox(width: 10),
              Text(currentText.volume, style: textStyles.smallBold)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.keyboard_arrow_up,
                  color: currentText.price.toLowerCase().contains("rising")
                      ? colors.borderColorPrimary
                      : colors.textColorSecondary,
                  size: 36),
              const SizedBox(width: 10),
              Image.asset("assets/rupee_icon.png",
                  package: 'tradeable_learn_widget/lib', height: 35),
              const SizedBox(width: 10),
              Icon(Icons.keyboard_arrow_down,
                  color: currentText.price.toLowerCase().contains("falling")
                      ? colors.borderColorPrimary
                      : colors.textColorSecondary,
                  size: 36),
              const Spacer(),
              Icon(Icons.arrow_upward,
                  color: currentText.price.toLowerCase().contains("rising")
                      ? colors.borderColorPrimary
                      : colors.textColorSecondary,
                  size: 36),
              const SizedBox(width: 10),
              Image.asset("assets/user_group.png",
                  package: 'tradeable_learn_widget/lib', height: 35),
              const SizedBox(width: 10),
              Icon(Icons.arrow_downward,
                  color: currentText.price.toLowerCase().contains("falling")
                      ? colors.borderColorPrimary
                      : colors.textColorSecondary,
                  size: 36),
            ],
          ),
          const SizedBox(height: 20),
          Text(widget.title, style: textStyles.mediumNormal),
          Text(widget.prompt,
              style: textStyles.smallNormal
                  .copyWith(color: colors.axisColor.withOpacity(0.7))),
          const SizedBox(height: 10),
          Slider(
            value: _sliderValue.toDouble(),
            min: 0,
            max: (widget.textData.length - 1).toDouble(),
            divisions: widget.textData.length - 1,
            label: currentText.volume,
            thumbColor: colors.axisColor,
            activeColor: colors.axisColor,
            inactiveColor: colors.buttonBorderColor,
            onChanged: (value) {
              setState(() {
                _sliderValue = value.toInt();
                manipulateCandles(_sliderValue);
                widget.onSliderChanged(_sliderValue);
              });
            },
          ),
          const SizedBox(height: 10),
          Text("Interpretation", style: textStyles.mediumNormal),
          Text(currentText.interpretation,
              style: textStyles.smallNormal
                  .copyWith(color: colors.axisColor.withOpacity(0.7))),
        ],
      ),
    );
  }
}
