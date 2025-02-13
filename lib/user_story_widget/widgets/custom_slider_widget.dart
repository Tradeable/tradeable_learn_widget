import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/custom_slider_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CustomSliderWidget extends StatefulWidget {
  final SliderData sliderData;

  const CustomSliderWidget({super.key, required this.sliderData});

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  double _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    int divisions = widget.sliderData.sliderPoints.length - 1;
    SliderPoint currentPoint =
        widget.sliderData.sliderPoints[_currentIndex.toInt()];

    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
              color: colors.cardBasicBackground,
              boxShadow: [
                BoxShadow(
                    color: colors.borderColorSecondary.withOpacity(0.6),
                    spreadRadius: 0.4)
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.buttonBorderColor)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Row(
                  children: [
                    Text(widget.sliderData.title,
                        style: textStyles.smallNormal),
                    const SizedBox(width: 10),
                    Text(widget.sliderData.subtext,
                        style: textStyles.smallNormal
                            .copyWith(color: colors.textColorSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Slider(
                value: _currentIndex,
                min: 0,
                max: divisions.toDouble(),
                thumbColor: colors.borderColorPrimary,
                activeColor: colors.borderColorPrimary,
                inactiveColor: colors.cardColorSecondary,
                divisions: divisions,
                onChanged: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (widget.sliderData.showDivision)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.sliderData.sliderPoints.length,
                      (index) {
                    return Text("D${index + 1}");
                  }),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 10),
        buildDataPoints(
            "Contract Price", currentPoint.contractPrice.toString()),
        buildDataPoints("Volatility", currentPoint.volatility.toString()),
        buildDataPoints("Theta", currentPoint.theta.toString()),
        buildDataPoints("Delta", currentPoint.delta.toString())
      ],
    );
  }

  Widget buildDataPoints(String title, String value) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: textStyles.smallNormal.copyWith(
                  color: colors.textColorSecondary,
                  fontWeight: title == "Contract Price"
                      ? FontWeight.bold
                      : FontWeight.normal)),
          Text(value, style: textStyles.smallNormal)
        ],
      ),
    );
  }
}
