import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/greeks_explainer_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class GreeksExplainerWidget extends StatefulWidget {
  final GreeksExplainerModel model;

  const GreeksExplainerWidget({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _GreeksExplainerWidget();
}

class _GreeksExplainerWidget extends State<GreeksExplainerWidget>
    with SingleTickerProviderStateMixin {
  late double sliderValue;
  int initialIndex = 0;

  @override
  void initState() {
    initialIndex = widget.model.strikePrices.indexWhere(
        (strikePrice) => strikePrice.value == widget.model.currentStrikePrice);
    sliderValue = initialIndex.toDouble();
    showCarAnimation();
    super.initState();
  }

  void showCarAnimation() {
    if (widget.model.showAnimation ?? false) {
      AnimationController controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );

      Tween<double> tween =
          Tween(begin: initialIndex.toDouble(), end: initialIndex + 2);
      Animation<double> animation = tween.animate(
        CurvedAnimation(parent: controller, curve: Curves.linear),
      );

      controller.forward();

      animation.addListener(() {
        setState(() {
          sliderValue = (animation.value * 10).round() / 10;
        });
      });

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.dispose();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          (widget.model.showSliderLabels ?? false)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: (widget.model.sliderLabels ?? [])
                        .map((label) => Text(
                              label,
                              style:
                                  textStyles.smallNormal.copyWith(fontSize: 12),
                            ))
                        .toList(),
                  ),
                )
              : Container(),
          Slider(
            value:
                double.parse(widget.model.sliderLabels![sliderValue.toInt()]),
            min: double.parse(widget.model.sliderLabels!.first),
            max: double.parse(widget.model.sliderLabels!.last),
            thumbColor: colors.axisColor,
            activeColor: colors.axisColor,
            inactiveColor: colors.secondary,
            onChanged: (val) {},
            divisions: widget.model.strikePrices.length - 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text("Premium: ", style: textStyles.smallNormal),
                const SizedBox(width: 4),
                Text(widget.model.premiumValues![sliderValue.toInt()],
                    style: textStyles.mediumBold),
                const Spacer(),
                widget.model.isOptionToggleVisible
                    ? Row(
                        children: [
                          Text("PUT",
                              style: textStyles.smallNormal.copyWith(
                                  color: widget.model.isCallOption
                                      ? colors.secondary
                                      : colors.axisColor)),
                          const SizedBox(width: 6),
                          Switch(
                            value: widget.model.isCallOption,
                            onChanged: (b) {},
                            activeColor: colors.cardBasicBackground,
                            activeTrackColor: colors.sliderColor,
                            inactiveThumbColor: colors.cardBasicBackground,
                            inactiveTrackColor: colors.bullishColor,
                          ),
                          const SizedBox(width: 6),
                          Text("CALL",
                              style: textStyles.smallNormal.copyWith(
                                  color: widget.model.isCallOption
                                      ? colors.axisColor
                                      : colors.secondary))
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                Positioned(
                    right: 0,
                    child: Image.asset(
                      "assets/fh1.png",
                      package: 'tradeable_learn_widget/lib',
                      height: 130,
                    )),
                Positioned(
                  left: ((MediaQuery.of(context).size.width /
                              widget.model.strikePrices.length) *
                          sliderValue -
                      10),
                  bottom: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.buttonColor,
                            border: Border.all(
                                color: colors.borderColorSecondary, width: 1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                                widget.model.strikePrices[sliderValue.toInt()]
                                    .value
                                    .toString(),
                                style: textStyles.smallBold.copyWith(
                                    color: widget
                                                .model
                                                .strikePrices[
                                                    sliderValue.toInt()]
                                                .title ==
                                            "ATM"
                                        ? colors.bullishColor
                                        : colors.borderColorPrimary)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        "assets/fc1.png",
                        package: 'tradeable_learn_widget/lib',
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 90,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Divider(
                      thickness: 3,
                      color: colors.secondary,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(widget.model.strikePrices.length,
                          (index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.model.strikePrices[index].value.toString(),
                              style:
                                  textStyles.smallNormal.copyWith(fontSize: 12),
                            ),
                            Text(
                              widget.model.strikePrices[index].title.toString(),
                              style: textStyles.smallNormal.copyWith(
                                  fontSize: 12,
                                  color:
                                      widget.model.strikePrices[index].title ==
                                              "ATM"
                                          ? colors.bullishColor
                                          : colors.bearishColor),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 70,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          widget.model.strikePrices.length * 2 - 1, (index) {
                        double lineHeight = index % 2 == 0 ? 30 : 15;
                        return Container(
                          width: 2,
                          height: lineHeight,
                          color: colors.secondary,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
